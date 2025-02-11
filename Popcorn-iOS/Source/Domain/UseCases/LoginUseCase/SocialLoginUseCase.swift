//
//  SocialLoginUseCase.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/28/25.
//

import Foundation
import KakaoSDKUser

protocol SocialLogionUseCaseProtocol {
    func loginWithKakao(completion: @escaping (Result<Bool, Error>) -> Void)
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

// MARK: - Private func
extension SocialLoginUseCase {
    private func loginWithKakaoTalk(completion: @escaping (Result<Bool, Error>) -> Void) {
        socialLoginRepository.loginWithKaKaoTalk { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.handleKakaoLoginSuccess(token: token, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func loginWithKakaoWeb(completion: @escaping (Result<Bool, any Error>) -> Void) {
        socialLoginRepository.loginWithKakaoWeb { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.handleKakaoLoginSuccess(token: token, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func handleKakaoLoginSuccess(token: Token, completion: @escaping (Result<Bool, Error>) -> Void) {
        tokenRepository.saveToken(with: token, loginType: "kakao")

        socialLoginRepository.fetchIdToken { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let idToken):
                self.checkNewUserWithIdToken(idToken: idToken, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func checkNewUserWithIdToken(idToken: IdToken, completion: @escaping (Result<Bool, Error>) -> Void) {
        socialLoginRepository.fetchNewUserResult(idToken: idToken.idToken) { result in
            switch result {
            case .success(let isNewUser):
                completion(.success(isNewUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Public interface
extension SocialLoginUseCase {
    func loginWithKakao(completion: @escaping (Result<Bool, Error>) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            loginWithKakaoTalk(completion: completion)
        } else {
            loginWithKakaoWeb(completion: completion)
        }
    }
}
