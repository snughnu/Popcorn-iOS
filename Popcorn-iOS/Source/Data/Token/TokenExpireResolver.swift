//
//  TokenExpireResolver.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/15/25.
//

import Foundation

final class TokenExpireResolver {
    private let tokenRepository = TokenRepository()

    func handleTokenExpiration(completion: @escaping (Bool) -> Void) {
        if let accessToken = tokenRepository.fetchAccessToken() {
            print("Access Token 유효: \(accessToken)")
            completion(true)
            return
        }

        if let refreshToken = tokenRepository.fetchRefreshToken() {
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
        } else {
            print("Refresh Token 만료")
            completion(false)
        }
    }
}
