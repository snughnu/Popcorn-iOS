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
    private let networkManager: NetworkManagerProtocol
    private let keychainManager: KeychainManagerProtocol

    init(
        networkManager: NetworkManagerProtocol,
        keychainManager: KeychainManagerProtocol
    ) {
        self.networkManager = networkManager
        self.keychainManager = keychainManager
    }

    private func saveIdToken(provider: String, idToken: String) -> Bool {
        return keychainManager.saveIdToken(provider: provider, idToken: IdToken(idToken: idToken))
    }
}

// MARK: - Public interface
extension SocialLoginRepository {
    func loginWithKaKaoTalk(completion: @escaping (Result<Token, Error>) -> Void) {
        UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let token = oauthToken else {
                completion(.failure(NSError(domain: "InvalidToken", code: -1, userInfo: nil)))
                return
            }

            let newToken = Token(
                accessToken: token.accessToken,
                refreshToken: token.refreshToken,
                accessExpiredAt: ISO8601DateFormatter().string(from: token.expiredAt),
                refreshExpiredAt: ISO8601DateFormatter().string(from: token.refreshTokenExpiredAt)
            )

            if let idToken = token.idToken {
                _ = self.saveIdToken(provider: "kakao", idToken: idToken)
            }

            completion(.success(newToken))
        }
    }

    func loginWithKakaoWeb(completion: @escaping (Result<Token, Error>) -> Void) {
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let token = oauthToken else {
                completion(.failure(NSError(domain: "InvalidToken", code: -1, userInfo: nil)))
                return
            }

            let newToken = Token(
                accessToken: token.accessToken,
                refreshToken: token.refreshToken,
                accessExpiredAt: ISO8601DateFormatter().string(from: token.expiredAt),
                refreshExpiredAt: ISO8601DateFormatter().string(from: token.refreshTokenExpiredAt)
            )

            if let idToken = token.idToken {
                _ = self.saveIdToken(provider: "kakao", idToken: idToken)
            }

            completion(.success(newToken))
        }
    }

    func fetchIdToken(completion: @escaping (Result<IdToken, Error>) -> Void) {
        guard let idTokenString = keychainManager.getIdToken(provider: "kakao") else {
            completion(.failure(NSError(domain: "IdTokenNotFound", code: -1)))
            return
        }

        let idToken = IdToken(idToken: idTokenString)
        completion(.success(idToken))
    }

    func fetchNewUserResult(idToken: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endPoint = JSONBodyEndpoint<SocialLoginResponseDTO>(
            httpMethod: .post,
            path: APIConstant.isKakaoUserPath,
            body: SocialLoginRequestDTO(idToken: idToken, provider: "KAKAO")
        )
        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let loginResponse):
                completion(.success(loginResponse.newUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
