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

    // MARK: - Private func
    private func saveIdTokenAndLoginType(
        idToken: IdToken,
        loginType: String,
        completion: @escaping (Result<IdToken, Error>) -> Void
    ) {
        let idTokenQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "idToken"
        ]
        let idTokenAttributes: [String: Any] = [
            kSecValueData as String: Data(idToken.idToken.utf8),
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        let loginTypeQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "loginType"
        ]
        let loginTypeAttributes: [String: Any] = [
            kSecValueData as String: Data(loginType.utf8),
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        let idTokenStatus = keychainManager.updateItem(with: idTokenQuery, as: idTokenAttributes)
        if idTokenStatus == errSecItemNotFound {
            let addQuery = idTokenQuery.merging(idTokenAttributes) { _, new in new }
            _ = keychainManager.addItem(with: addQuery)
        }

        let loginTypeStatus = keychainManager.updateItem(with: loginTypeQuery, as: loginTypeAttributes)
        if loginTypeStatus == errSecItemNotFound {
            let addQuery = loginTypeQuery.merging(loginTypeAttributes) { _, new in new }
            _ = keychainManager.addItem(with: addQuery)
        }

        completion(.success(idToken))
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
            self.saveIdTokenAndLoginType(idToken: idToken, loginType: "kakao", completion: completion)
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
            self.saveIdTokenAndLoginType(idToken: idToken, loginType: "kakao", completion: completion)
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
                self.saveIdTokenAndLoginType(idToken: idToken, loginType: "apple", completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

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
