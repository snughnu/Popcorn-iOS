//
//  SocialLoginRepository.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/28/25.
//

import Foundation
import KakaoSDKUser

// MARK: - Public interface
final class SocialLoginRepository: SocialLoginRepositoryProtocol {
   // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let keychainManager: KeychainManagerProtocol
    private let appleLoginManager: AppleLoginManagerProtocol

    // MARK: - Initializer
    init(
        networkManager: NetworkManagerProtocol,
        keychainManager: KeychainManagerProtocol,
        appleLoginManager: AppleLoginManagerProtocol
    ) {
        self.networkManager = networkManager
        self.keychainManager = keychainManager
        self.appleLoginManager = appleLoginManager
    }
}

// MARK: - Public interface for kakao
extension SocialLoginRepository {
    func isKakaoTalkLoginAvailable() -> Bool {
        return UserApi.isKakaoTalkLoginAvailable()
    }

    func loginWithKakaoTalk(completion: @escaping (Result<IdToken, Error>) -> Void) {
        UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let token = oauthToken,
                  let idTokenString = token.idToken else {
                completion(.failure(NSError(domain: "InvalidToken", code: -1)))
                return
            }

            let idToken = IdToken(idToken: idTokenString)
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "idToken"
            ]
            let attributes: [String: Any] = [
                kSecValueData as String: Data(idToken.idToken.utf8),
                kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
            ]
            let status = self.keychainManager.updateItem(with: query, as: attributes)
            if status == errSecItemNotFound {
                let addQuery = query.merging(attributes) { _, new in new }
                let addStatus = self.keychainManager.addItem(with: addQuery)
                if addStatus != errSecSuccess {
                    completion(.failure(NSError(domain: "KeychainError", code: Int(addStatus))))
                    return
                }
                else if status != errSecSuccess {
                    completion(.failure(NSError(domain: "KeychainError", code: Int(status))))
                    return
                }
                completion(.success(idToken))
            }
        }
    }

    func loginWithKakaoWeb(completion: @escaping (Result<IdToken, Error>) -> Void) {
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let token = oauthToken,
                  let idTokenString = token.idToken else {
                completion(.failure(NSError(domain: "InvalidToken", code: -1)))
                return
            }

            let idToken = IdToken(idToken: idTokenString)
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "idToken"
            ]
            let attributes: [String: Any] = [
                kSecValueData as String: Data(idToken.idToken.utf8),
                kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
            ]
            let status = self.keychainManager.updateItem(with: query, as: attributes)
            if status == errSecItemNotFound {
                let addQuery = query.merging(attributes) { _, new in new }
                let addStatus = self.keychainManager.addItem(with: addQuery)
                if addStatus != errSecSuccess {
                    completion(.failure(NSError(domain: "KeychainError", code: Int(addStatus))))
                    return
                }
            } else if status != errSecSuccess {
                completion(.failure(NSError(domain: "KeychainError", code: Int(status))))
                return
            }
            completion(.success(idToken))
        }
    }

    func fetchNewKakaoUserResult(
        idToken: String,
        completion: @escaping (Result<SocialLoginResponseDTO, Error>) -> Void
    ) {
        let endPoint = JSONBodyEndpoint<SocialLoginResponseDTO>(
            httpMethod: .post,
            path: APIConstant.isKakaoUserPath,
            body: SocialLoginRequestDTO(idToken: idToken, provider: "KAKAO")
        )
        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let loginResponse):
                completion(.success(loginResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Public interface for apple
extension SocialLoginRepository {
    // MARK: - Apple
    func loginWithApple(completion: @escaping (Result<IdToken, Error>) -> Void) {
        appleLoginManager.loginWithApple { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let idToken):
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: "idToken"
                ]
                let attributes: [String: Any] = [
                    kSecValueData as String: Data(idToken.idToken.utf8),
                    kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
                ]
                let status = self.keychainManager.updateItem(with: query, as: attributes)
                if status == errSecItemNotFound {
                    let addQuery = query.merging(attributes) { _, new in new }
                    let addStatus = self.keychainManager.addItem(with: addQuery)
                    if addStatus != errSecSuccess {
                        completion(.failure(NSError(domain: "KeychainError", code: Int(addStatus), userInfo: nil)))
                        return
                    }
                } else if status != errSecSuccess {
                    completion(.failure(NSError(domain: "KeychainError", code: Int(status), userInfo: nil)))
                    return
                }
                completion(.success(idToken))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // TODO: - API 나온 후 리팩토링
    func fetchNewAppleUserResult(
        idToken: String,
        completion: @escaping (Result<SocialLoginResponseDTO, Error>) -> Void
    ) {
        let endPoint = JSONBodyEndpoint<SocialLoginResponseDTO>(
            httpMethod: .post,
            path: APIConstant.isAppleUserPath,
            body: SocialLoginRequestDTO(idToken: idToken, provider: "APPLE")
        )
        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let loginResponse):
                completion(.success(loginResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
