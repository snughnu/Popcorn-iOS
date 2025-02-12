//
//  SocialLoginUseCase.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/28/25.
//

import Foundation

protocol SocialLogionUseCaseProtocol {
    func loginWithKakao(completion: @escaping (Result<Bool, Error>) -> Void)
}

final class SocialLoginUseCase: SocialLogionUseCaseProtocol {
    // MARK: - Properties
    private let socialLoginRepository: SocialLoginRepositoryProtocol
    private let tokenRepository: TokenRepositoryProtocol

    // MARK: - Initializer
    init(
        socialLoginRepository: SocialLoginRepositoryProtocol,
        tokenRepository: TokenRepositoryProtocol
    ) {
        self.socialLoginRepository = socialLoginRepository
        self.tokenRepository = tokenRepository
    }

    // MARK: - Private func
    private func handleKakaoLoginResult(
        _ result: Result<IdToken, Error>,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        switch result {
        case .success(let idToken):
            socialLoginRepository.fetchNewUserResult(idToken: idToken.idToken) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    if response.newUser {
                        completion(.success(true))
                    } else if let token = response.toToken() {
                        self.tokenRepository.saveToken(with: token, loginType: "kakao")
                        completion(.success(false))
                    } else {
                        let error = NSError(domain: "ServerError",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "토큰이 없습니다."])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

// MARK: - Public interface
extension SocialLoginUseCase {
    func loginWithKakao(completion: @escaping (Result<Bool, Error>) -> Void) {
        if socialLoginRepository.isKakaoTalkLoginAvailable() {
            socialLoginRepository.loginWithKakaoTalk { [weak self] result in
                guard let self = self else { return }
                self.handleKakaoLoginResult(result, completion: completion)
            }
        } else {
            socialLoginRepository.loginWithKakaoWeb { [weak self] result in
                guard let self = self else { return }
                self.handleKakaoLoginResult(result, completion: completion)
            }
        }
    }
}
