//
//  SocialLoginViewModel.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/27/25.
//

import Foundation
import KakaoSDKUser

final class SocialLoginViewModel {
    // MARK: - Properties
    private let socialLoginUseCase: SocialLogionUseCaseProtocol

    // MARK: - Output
    var loginSuccessHandler: ((String) -> Void)?
    var loginFailHandler: ((Error) -> Void)?

    // MARK: - Initializer
    init(socialLoginUseCase: SocialLogionUseCaseProtocol) {
        self.socialLoginUseCase = socialLoginUseCase
    }
}

// MARK: - Public methods
extension SocialLoginViewModel {
    func loginWithKakao() {
        if UserApi.isKakaoTalkLoginAvailable() {
            loginWithKaKaoTalk()
        } else {
            loginWithKakaoWeb()
        }
    }
}

// MARK: - Private methods
extension SocialLoginViewModel {
    func loginWithKaKaoTalk() {
        socialLoginUseCase.loginWithKakaoTalk { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nickname):
                    self?.loginSuccessHandler?(nickname)
                case .failure(let error):
                    self?.loginFailHandler?(error)
                }
            }
        }
    }

    func loginWithKakaoWeb() {
        socialLoginUseCase.loginWithKakaoWeb { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nickname):
                    self?.loginSuccessHandler?(nickname)
                case .failure(let error):
                    self?.loginFailHandler?(error)
                }
            }
        }
    }
}
