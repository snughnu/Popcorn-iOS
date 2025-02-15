//
//  TokenRepository.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/13/25.
//

import Foundation
import KakaoSDKAuth

final class TokenRepository: TokenRepositoryProtocol {
    // MARK: - Properties
    private let keychainManager: KeychainManagerProtocol
    private let networkManager: NetworkManagerProtocol

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
    private let accessExpiredAtAttributes: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: "Popcorn",
        kSecAttrService as String: "accessExpiredAt"
    ]
    private let refreshExpiredAtAttributes: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: "Popcorn",
        kSecAttrService as String: "refreshExpiredAt"
    ]
    private let loginTypeAttributes: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: "Popcorn",
        kSecAttrService as String: "loginType"
    ]
    private let fetchQuery: [String: Any] = [
        kSecMatchLimit as String: kSecMatchLimitOne,
        kSecReturnData as String: true
    ]

    // MARK: - Initializer
    init(
        networkManager: NetworkManagerProtocol,
        keychainManager: KeychainManagerProtocol
    ) {
        self.networkManager = networkManager
        self.keychainManager = keychainManager
    }

    // MARK: - Private Methods
    private func convertTokenToSecValueData(token: String) -> [String: Any]? {
        guard let data = token.data(using: .utf8) else { return nil }
        return [kSecValueData as String: data]
    }

    private func addOrUpdateKeychainItem(attributes: [String: Any], value: String) {
        guard let data = value.data(using: .utf8) else { return }

        var item = attributes
        item[kSecValueData as String] = data

        _ = keychainManager.deleteItem(with: attributes)
        _ = keychainManager.addItem(with: item)
    }
}

// MARK: - Public base method
extension TokenRepository {
    func saveToken(with token: Token, loginType: String?) {
        addOrUpdateKeychainItem(attributes: accessTokenAttributes, value: token.accessToken)
        addOrUpdateKeychainItem(attributes: refreshTokenAttributes, value: token.refreshToken)
        addOrUpdateKeychainItem(attributes: accessExpiredAtAttributes, value: token.accessExpiredAt)
        addOrUpdateKeychainItem(attributes: refreshExpiredAtAttributes, value: token.refreshExpiredAt)
        if let loginType = loginType {
            addOrUpdateKeychainItem(attributes: loginTypeAttributes, value: loginType)
        }
    }

    func deleteTokens() {
        _ = keychainManager.deleteItem(with: accessTokenAttributes)
        _ = keychainManager.deleteItem(with: refreshTokenAttributes)
        _ = keychainManager.deleteItem(with: accessExpiredAtAttributes)
        _ = keychainManager.deleteItem(with: refreshExpiredAtAttributes)
        _ = keychainManager.deleteItem(with: loginTypeAttributes)
    }
}

// MARK: - Public fetch method
extension TokenRepository {
    func fetchAccessToken() -> String? {
        let query = accessTokenAttributes.merging(fetchQuery) { _, new in new }
        guard let data = keychainManager.fetchItem(with: query) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func fetchRefreshToken() -> String? {
        let query = refreshTokenAttributes.merging(fetchQuery) { _, new in new }
        guard let data = keychainManager.fetchItem(with: query) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func fetchAccessTokenExpirationDate() -> Date? {
        let query = accessExpiredAtAttributes.merging(fetchQuery) { _, new in new }
        guard let data = keychainManager.fetchItem(with: query),
              let expiredAtString = String(data: data, encoding: .utf8) else { return nil }
        return DateFormatter.apiDateFormatter.date(from: expiredAtString)
    }

    func fetchRefreshTokenExpirationDate() -> Date? {
        let query = refreshExpiredAtAttributes.merging(fetchQuery) { _, new in new }
        guard let data = keychainManager.fetchItem(with: query),
              let expiredAtString = String(data: data, encoding: .utf8) else { return nil }
        return DateFormatter.apiDateFormatter.date(from: expiredAtString)
    }

    func fetchLoginType() -> String? {
        let query = loginTypeAttributes.merging(fetchQuery) { _, new in new }
        guard let data = keychainManager.fetchItem(with: query) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

// MARK: - Public reissue method
extension TokenRepository {
    func reissueAccessToken(refreshToken: String, completion: @escaping (Result<NewToken, Error>) -> Void) {
        let endPoint = Endpoint<ReissueResponseDTO>(
            httpMethod: .post,
            path: APIConstant.reissueTokenPath,
            headers: ["X-refresh-token": "\(refreshToken)"]
        )

        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let reissueResponse):
                let newToken = reissueResponse.data
                self.saveToken(with: Token(
                    accessToken: newToken.accessToken,
                    refreshToken: newToken.refreshToken,
                    accessExpiredAt: newToken.accessExpiredAt,
                    refreshExpiredAt: newToken.refreshExpiredAt
                ), loginType: self.fetchLoginType() ?? "custom")
                completion(.success(newToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
