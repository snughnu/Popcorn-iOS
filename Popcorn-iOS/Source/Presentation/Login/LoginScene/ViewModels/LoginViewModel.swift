//
//  LoginViewModel.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/26/25.
//

import Foundation

final class LoginViewModel {
    // MARK: - Properties
    private let loginManager: LoginManager

    private var username: String = "" {
        didSet { updateLoginButtonEnabled() }
    }

    private var password: String = "" {
        didSet { updateLoginButtonEnabled() }
    }

    private var isLoginButtonEnabled: Bool = false {
        didSet { loginButtonEnabledHandler?(isLoginButtonEnabled) }
    }

    // MARK: - Output
    var loginButtonEnabledHandler: ((Bool) -> Void)?
    var loginSuccessHandler: (() -> Void)?
    var loginFailHandler: ((String) -> Void)?

    // MARK: - Initializer
    init (loginManager: LoginManager = LoginManager(
        networkManager: NetworkManager(),
        tokenRepository: TokenRepository()
    )) {
        self.loginManager = loginManager
    }

    private func updateLoginButtonEnabled() {
        isLoginButtonEnabled = !username.isEmpty && !password.isEmpty
    }
}

// MARK: - Input
extension LoginViewModel {
    func updateUsername(_ username: String) {
        self.username = username
    }

    func updatePassword(_ password: String) {
        self.password = password
    }
}

// MARK: - Public method
extension LoginViewModel {
    func login() {
        guard !username.isEmpty, !password.isEmpty else {
            loginFailHandler?("아이디 또는 비밀번호를 입력해주세요.")
            return
        }

        loginManager.login(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.loginSuccessHandler?()
                case .failure:
                    self?.loginFailHandler?("아이디 또는 비밀번호를 확인해주세요.")
                }
            }
        }
    }
}
