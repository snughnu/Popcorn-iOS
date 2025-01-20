//
//  TokenRepository.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/13/25.
//

import Foundation

final class TokenRepository {
    private let keychainManager = KeychainManager()
    private let accessTokenAttributes: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: "Popcorn",
        kSecAttrService as String: "accessToken"
    ]
    private let refreshTokenAttributes: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: "Popcorn",
        kSecAttrService as String: "refreshToken"
    ]
    private let fetchQuery: [String: Any] = [
        kSecMatchLimit as String: kSecMatchLimitOne,
        kSecReturnData as String: true
    ]

    private func convertTokenToSecValueData(token: String) -> [String: Any]? {
        guard let data = token.data(using: .utf8) else {
            return nil
        }
        return [kSecValueData as String: data]
    }

    func saveToken(with token: Token, loginType: String? = nil) {
        guard let accessToken = convertTokenToSecValueData(token: token.accessToken),
              let refreshToken = convertTokenToSecValueData(token: token.refreshToken) else {
            return
        }

        let accessTokenAttributesWithData = accessTokenAttributes.merging(accessToken) { _, new in new }
        let refreshTokenAttributesWithData = refreshTokenAttributes.merging(refreshToken) { _, new in new }

        let accessStatus = keychainManager.addItem(with: accessTokenAttributesWithData)
        let refreshStatus = keychainManager.addItem(with: refreshTokenAttributesWithData)

        if accessStatus == errSecDuplicateItem || refreshStatus == errSecDuplicateItem {
            updateToken(with: token)
        }

        if let loginType = loginType {
            let loginTypeAttributes: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "Popcorn",
                kSecAttrService as String: "loginType",
                kSecValueData as String: loginType.data(using: .utf8)!
            ]

            let loginTypeStatus = keychainManager.addItem(with: loginTypeAttributes)
            if loginTypeStatus == errSecDuplicateItem {
                keychainManager.updateItem(with: loginTypeAttributes,
                                           as: [kSecValueData as String: loginType.data(using: .utf8)!])
            }
        }
    }

    func updateToken(with token: Token) {
        guard let accessToken = convertTokenToSecValueData(token: token.accessToken),
              let refreshToken = convertTokenToSecValueData(token: token.refreshToken) else {
            return
        }

        _ = keychainManager.updateItem(with: accessTokenAttributes, as: accessToken)
        _ = keychainManager.updateItem(with: refreshTokenAttributes, as: refreshToken)
    }

    func fetchAccessToken() -> String? {
        let query = accessTokenAttributes.merging(fetchQuery) { _, new in new }
        guard let item = keychainManager.fetchItem(with: query),
              let data = item as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        return token
    }

    func fetchRefreshToken() -> String? {
        let query = refreshTokenAttributes.merging(fetchQuery) { _, new in new }
        guard let item = keychainManager.fetchItem(with: query),
              let data = item as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        return token
    }

    func fetchLoginType() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "Popcorn",
            kSecAttrService as String: "loginType",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        guard let item = keychainManager.fetchItem(with: query),
              let data = item as? Data,
              let loginType = String(data: data, encoding: .utf8) else {
            return nil
        }
        return loginType
    }

    func deleteTokens() {
        keychainManager.deleteItem(with: accessTokenAttributes)
        keychainManager.deleteItem(with: refreshTokenAttributes)
    }
}

// MARK: - AccessToken 재발급 메서드
extension TokenRepository {
    func reissueAccessToken(refreshToken: String, completion: @escaping (Result<Token, Error>) -> Void) {
        let url = URL(string: "https://popcorm.store/reissue")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(refreshToken, forHTTPHeaderField: "X-refresh-token")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("토큰 재발급 요청 실패: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                print("토큰 재발급 응답 없음 또는 잘못된 응답")
                completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                return
            }

            print("응답 상태 코드: \(httpResponse.statusCode)")
            print("응답 데이터: \(String(data: data, encoding: .utf8) ?? "디코딩 실패")")

            do {
                let decoder = JSONDecoder()
                let reissueResponse = try decoder.decode(ReissueResponse<NewToken>.self, from: data)

                if httpResponse.statusCode == 200 {
                    let newToken = reissueResponse.data
                    let token = Token(
                        accessToken: newToken.accessToken,
                        refreshToken: newToken.refreshToken,
                        accessExpiredAt: newToken.accessExpiredAt,
                        refreshExpiredAt: newToken.refreshExpiredAt
                    )
                    completion(.success(token))
                } else {
                    let errorMessage = String(data: data, encoding: .utf8) ?? "알 수 없는 오류"
                    print("토큰 재발급 실패. 상태 코드: \(httpResponse.statusCode), 오류 메시지: \(errorMessage)")
                    completion(.failure(NSError(domain: "ReissueFailed",
                                                code: httpResponse.statusCode,
                                                userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
            } catch {
                print("토큰 재발급 데이터 처리 실패: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
