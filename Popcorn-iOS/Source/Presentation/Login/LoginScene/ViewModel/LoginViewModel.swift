//
//  LoginViewModel.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/26/25.
//

import Foundation

final class LoginViewModel {
    private let loginManager: LoginManager

    // MARK: - Input
    var username: String = "" {
        didSet { updateLoginButtonState() }
    }
    var password: String = "" {
        didSet { updateLoginButtonState() }
    }

    // MARK: - Output
    var isLoginButtonEnabled: ((Bool) -> Void)?
    var errorMessage: ((String) -> Void)?
    var loginSuccess: (() -> Void)?

    // MARK: - Initializer
    init (loginManager: LoginManager = LoginManager(
        networkManager: NetworkManager(),
        tokenRepository: TokenRepository()
    )) {
        self.loginManager = loginManager
    }

    private func updateLoginButtonState() {
        let isValid = !username.isEmpty && !password.isEmpty
        isLoginButtonEnabled?(isValid)
    }

    func login() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage?("아이디 또는 비밀번호를 입력해주세요.")
            return
        }

        loginManager.login(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.loginSuccess?()
                case .failure:
                    self?.errorMessage?("아이디 또는 비밀번호를 확인해주세요.")
                }
            }
        }
    }
}
