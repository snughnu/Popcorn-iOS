//
//  SignUpSecondViewModel.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/13/25.
//

import Foundation

protocol SignUpSecondViewModelProtocol {
    var selectedProfileId: Int? { get set }
    var profileImageUpdateHandler: ((Int) -> Void)? { get set }
    var signUpResultHandler: ((Bool, String) -> Void)? { get set }

    func updateSelectedProfile(index: Int)
    func updateSelectedInterests(_ interests: [String])
    func sendSignUpData(nickName: String)
}

final class SignUpSecondViewModel: SignUpSecondViewModelProtocol {
    // MARK: - Properties
    private let signUpUseCase: SignUpUseCaseProtocol
    var selectedProfileId: Int?
    var selectedInterests: [String] = []
    var profileImageUpdateHandler: ((Int) -> Void)?
    var signUpResultHandler: ((Bool, String) -> Void)?

    // MARK: - Initializer
    init(
        signUpUseCase: SignUpUseCaseProtocol
    ) {
        self.signUpUseCase = signUpUseCase
    }
}

// MARK: - Public interface
extension SignUpSecondViewModel {
    func updateSelectedProfile(index: Int) {
        self.selectedProfileId = index
        profileImageUpdateHandler?(index)
    }

    func updateSelectedInterests(_ interests: [String]) {
        self.selectedInterests = interests
    }

    func sendSignUpData(nickName: String) {
        guard let profileId = selectedProfileId else {
            signUpResultHandler?(false, "프로필을 선택해주세요.")
            return
        }

        guard !selectedInterests.isEmpty else {
            signUpResultHandler?(false, "관심사를 하나 이상 선택해주세요.")
            return
        }

        signUpUseCase.executeSignUp(
            nickName: nickName,
            profileId: profileId,
            interests: selectedInterests
        ) { [ weak self ] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case . success(let isSuccess):
                    if isSuccess {
                        self.signUpResultHandler?(true, "로그인 화면으로 이동합니다.")
                    } else {
                        self.signUpResultHandler?(false, "이미 가입된 이메일입니다.")
                    }
                case .failure(let error):
                    self.signUpResultHandler?(false, "\(error.localizedDescription)")
                }
            }
        }
    }
}
