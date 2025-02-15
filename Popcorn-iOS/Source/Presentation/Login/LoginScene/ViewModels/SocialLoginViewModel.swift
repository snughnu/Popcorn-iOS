//
//  SocialLoginViewModel.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/27/25.
//

import Foundation

protocol SocialLoginViewModelProtocol {
    var loginSuccessHandler: ((Bool) -> Void)? { get set }
    var loginFailHandler: ((String) -> Void)? { get set }

    func loginWithKakao()
}

final class SocialLoginViewModel: SocialLoginViewModelProtocol {
    // MARK: - Properties
    private let socialLoginUseCase: SocialLogionUseCaseProtocol

    // MARK: - Output
    var loginSuccessHandler: ((Bool) -> Void)?
    var loginFailHandler: ((String) -> Void)?

    // MARK: - Initializer
    init(
        socialLoginUseCase: SocialLogionUseCaseProtocol
    ) {
        self.socialLoginUseCase = socialLoginUseCase
    }
}

// MARK: - Public methods
extension SocialLoginViewModel {
    func loginWithKakao() {
        socialLoginUseCase.loginWithKakao { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let isNewUser):
                    self.loginSuccessHandler?(isNewUser)
                case .failure:
                    self.loginFailHandler?("카카오 로그인 실패")
                }
            }
        }
    }
}
