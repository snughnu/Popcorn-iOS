//
//  SignUpSecondViewModel.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/13/25.
//

import Foundation

protocol SignUpSecondViewModelProtocol {
    func presentProfileImageView()
    func updateAllAgreeButtonState()
    func updateFirstAgreeButtonState()
    func updateSecondAgreeButtonState()
    func signUp()
}

final class SignUpSecondViewModel: SignUpSecondViewModelProtocol {
    private let signUpUseCase: SignUpUseCaseProtocol

    init(
        signUpUseCase: SignUpUseCaseProtocol
    ) {
        self.signUpUseCase = signUpUseCase
    }
}
