//
//  SocialLoginUseCase.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/28/25.
//

import Foundation

protocol SocialLogionUseCaseProtocol {
    func loginWithKakaoTalk(completion: @escaping (Result<String, Error>) -> Void)
    func loginWithKakaoWeb(completion: @escaping (Result<String, Error>) -> Void)
}

final class SocialLoginUseCase: SocialLogionUseCaseProtocol {
    private let socialLoginRepository: SocialLoginRepositoryProtocol
    private let tokenRepository: TokenRepositoryProtocol

    init(
        socialLoginRepository: SocialLoginRepositoryProtocol,
        tokenRepository: TokenRepositoryProtocol
    ) {
        self.socialLoginRepository = socialLoginRepository
        self.tokenRepository = tokenRepository
    }
}

// MARK: - Public interface
extension SocialLoginUseCase {
    func loginWithKakaoTalk(completion: @escaping (Result<String, any Error>) -> Void) {
        socialLoginRepository.loginWithKaKaoTalk { [weak self] result in
            switch result {
            case .success(let token):
                self?.tokenRepository.saveToken(with: token, loginType: "kakao")
                self?.socialLoginRepository.fetchUserInfo(completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loginWithKakaoWeb(completion: @escaping (Result<String, any Error>) -> Void) {
        socialLoginRepository.loginWithKakaoWeb { [weak self] result in
            switch result {
            case .success(let token):
                self?.tokenRepository.saveToken(with: token, loginType: "kakao")
                self?.socialLoginRepository.fetchUserInfo(completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
