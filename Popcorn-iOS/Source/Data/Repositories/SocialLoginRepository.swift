//
//  SocialLoginRepository.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/28/25.
//

import Foundation
import KakaoSDKUser

protocol SocialLoginRepositoryProtocol {
    func loginWithKaKaoTalk(completion: @escaping (Result<Token, Error>) -> Void)
    func loginWithKakaoWeb(completion: @escaping (Result<Token, Error>) -> Void)
    func fetchUserInfo(completion: @escaping (Result<String, Error>) -> Void)
    func sendTokenToServer(completion: @escaping () -> Void)
}

// MARK: - Public interface
final class SocialLoginRepository: SocialLoginRepositoryProtocol {
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
            completion(.success(newToken))
        }
    }

    func fetchUserInfo(completion: @escaping (Result<String, Error>) -> Void) {
        UserApi.shared.me { user, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let nickname = user?.kakaoAccount?.profile?.nickname else {
                completion(.failure(NSError(domain: "InvalidUser", code: -1, userInfo: nil)))
                return
            }
            completion(.success(nickname))
        }
    }

    func sendTokenToServer(completion: @escaping () -> Void) {
        // TODO: 서버와 통신
    }
}
