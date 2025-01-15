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

    func saveToken(with token: Token) {
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
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data else {
                completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.apiDateFormatter)
                let loginResponse = try decoder.decode(LoginResponse.self, from: data)

                if loginResponse.status == "success" {
                    completion(.success(loginResponse.data))
                } else {
                    completion(.failure(NSError(domain: "ReissueFailed",
                                                code: loginResponse.resultCode,
                                                userInfo: nil
                                               )))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
