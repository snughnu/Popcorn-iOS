//
//  TokenExpireResolver.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/15/25.
//

import Foundation
import KakaoSDKAuth

final class TokenExpireResolver {
    private let tokenRepository = TokenRepository()

    func handleTokenExpiration(completion: @escaping (Bool) -> Void) {
        let loginType = tokenRepository.fetchLoginType()

        if let accessToken = tokenRepository.fetchAccessToken() {
            print("Access Token 유효: \(accessToken)")
            completion(true)
            return
        }

        if let refreshToken = tokenRepository.fetchRefreshToken() {
            if loginType == "kakao" {
                AuthApi.shared.refreshToken { [weak self] oauthToken, error in
                    if let error = error {
                        print("카카오 Access Token 재발급 실패: \(error.localizedDescription)")
                        completion(false)
                    } else if let oauthToken = oauthToken {
                        print("카카오 Access Token 재발급 성공")
                        let newToken = Token(
                            accessToken: oauthToken.accessToken,
                            refreshToken: oauthToken.refreshToken,
                            accessExpiredAt: ISO8601DateFormatter().string(from: oauthToken.expiredAt),
                            refreshExpiredAt: ISO8601DateFormatter().string(from: oauthToken.refreshTokenExpiredAt)
                        )
                        self?.tokenRepository.saveToken(with: newToken)
                        completion(true)
                    }
                }
            } else {
                tokenRepository.reissueAccessToken(refreshToken: refreshToken) { result in
                    switch result {
                    case .success(let newToken):
                        print("새로운 Access Token 발급 성공")
                        self.tokenRepository.saveToken(with: newToken)
                        completion(true)
                    case .failure:
                        print("Access Token 재발급 실패")
                        completion(false)
                    }
                }
            }
        } else {
            print("Refresh Token 만료")
            completion(false)
        }
    }
}
