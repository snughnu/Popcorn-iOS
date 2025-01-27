//
//  SocialLoginViewModel.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/27/25.
//

import KakaoSDKUser
import Foundation

final class SocialLoginViewModel {
    // MARK: - Properties
    private let tokenRepository: TokenRepository

    // MARK: - Output
    var loginSuccess: ((String) -> Void)?
    var loginFailure: ((Error) -> Void)?

    // MARK: - Initializer
    init(tokenRepository: TokenRepository = TokenRepository()) {
        self.tokenRepository = tokenRepository
    }
}

// MARK: - Public methods
extension SocialLoginViewModel {
    func loginWithKaKaoTalk() {
        UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
            if let error = error {
                self?.loginFailure?(error)
                return
            }
            guard let token = oauthToken else { return }
            let newToken = Token(
                accessToken: token.accessToken,
                refreshToken: token.refreshToken,
                accessExpiredAt: ISO8601DateFormatter().string(from: token.expiredAt),
                refreshExpiredAt: ISO8601DateFormatter().string(from: token.refreshTokenExpiredAt)
            )
            self?.tokenRepository.saveToken(with: newToken, loginType: "kakao")
            self?.fetchUserInfo()
            self?.sendTokenToServer()
        }
    }

    func loginWithKakaoWeb() {
        UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
            if let error = error {
                self?.loginFailure?(error)
                return
            }

            guard let token = oauthToken else { return }
            let newToken = Token(
                accessToken: token.accessToken,
                refreshToken: token.refreshToken,
                accessExpiredAt: ISO8601DateFormatter().string(from: token.expiredAt),
                refreshExpiredAt: ISO8601DateFormatter().string(from: token.refreshTokenExpiredAt)
            )
            self?.tokenRepository.saveToken(with: newToken, loginType: "kakao")
            self?.fetchUserInfo()
            self?.sendTokenToServer()
        }
    }

    private func fetchUserInfo() {
        UserApi.shared.me { [weak self] (user, error) in
            if let error = error {
                self?.loginFailure?(error)
                return
            }
            guard let nickname = user?.kakaoAccount?.profile?.nickname else { return }
            self?.loginSuccess?(nickname)
        }
    }

    private func sendTokenToServer() {
        // TODO: 서버로 토큰 보내기
    }
}
