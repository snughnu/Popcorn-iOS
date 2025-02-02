//
//  TokenUseCase.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/15/25.
//

import Foundation

protocol TokenUseCaseProtocol {
    func handleTokenExpiration(completion: @escaping (Bool) -> Void)
}

final class TokenUseCase: TokenUseCaseProtocol {
    // MARK: - Properties
    private let tokenRepository: TokenRepositoryProtocol

    // MARK: - Initializer
    init(tokenRepository: TokenRepositoryProtocol) {
        self.tokenRepository = tokenRepository
    }

    // MARK: - Private Method
    private func handleRefreshTokenExpiration(completion: @escaping (Bool) -> Void) {
        guard let refreshTokenExpirationDate = tokenRepository.fetchRefreshTokenExpirationDate(),
              refreshTokenExpirationDate >= Date(),
              let loginType = tokenRepository.fetchLoginType(),
              let refreshToken = tokenRepository.fetchRefreshToken() else {
            completion(false)
            return
        }
        reissueAccessTokenBasedOnLoginType(loginType: loginType, refreshToken: refreshToken, completion: completion)
    }

    private func reissueAccessTokenBasedOnLoginType(
        loginType: String,
        refreshToken: String,
        completion: @escaping (Bool) -> Void
    ) {
        switch loginType {
        case "custom":
            tokenRepository.reissueAccessToken(refreshToken: refreshToken) { result in
                switch result {
                case .success:
                    completion(true)
                case .failure:
                    completion(false)
                }
            }
        case "kakao":
            tokenRepository.reissueKakaoAccessToken(refreshToken: refreshToken) { result in
                switch result {
                case .success:
                    completion(true)
                case .failure:
                    completion(false)
                }
            }
        default:
            completion(false)
        }
    }
}

// MARK: - Public method
extension TokenUseCase {
    func handleTokenExpiration(completion: @escaping (Bool) -> Void) {
        guard (tokenRepository.fetchAccessToken()) != nil else {
            return handleRefreshTokenExpiration(completion: completion)
        }
        guard let accessTokenExpirationDate = tokenRepository.fetchAccessTokenExpirationDate(),
              accessTokenExpirationDate >= Date() else {
            return handleRefreshTokenExpiration(completion: completion)
        }
        completion(true)
    }
}
