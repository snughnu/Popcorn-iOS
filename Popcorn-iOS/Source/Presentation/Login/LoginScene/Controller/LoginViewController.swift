//
//  LoginViewController.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/19/24.
//

import KakaoSDKUser
import UIKit

class LoginViewController: UIViewController {
    private let loginView = LoginView()

    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddTarget()
        setupTextField()
    }

    private func setupAddTarget() {
        loginView.pwEyeButton.addTarget(self, action: #selector(passwordEyeButtonTapped), for: .touchUpInside)
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginView.findButton.addTarget(self, action: #selector(findButtonTapped), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        loginView.kakaoButton.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
        loginView.googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        loginView.appleButton.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
    }

    @objc private func passwordEyeButtonTapped() {
        loginView.pwTextField.isSecureTextEntry.toggle()
    }

    @objc private func loginButtonTapped() {
        guard let username = loginView.idTextField.text, !username.isEmpty,
              let password = loginView.pwTextField.text, !password.isEmpty else {
            updateErrorLabel(message: "아이디 또는 비밀번호를 입력해주세요.")
            return
        }

        LoginManager.shared.login(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    self?.handleLoginSuccess(token)
                case .failure:
                    self?.updateErrorLabel(message: "아이디 또는 비밀번호를 확인해주세요.")
                }
            }
        }
    }

    private func updateErrorLabel(message: String) {
        loginView.checkIdPwLabel.textColor = .red
        loginView.checkIdPwLabel.text = message
    }

    private func handleLoginSuccess(_ token: Token) {
        let tokenRepository = TokenRepository()
        tokenRepository.saveToken(with: token)

        let mainSceneViewController = MainSceneViewController()
        navigationController?.setViewControllers([mainSceneViewController], animated: true)
    }

    @objc private func findButtonTapped() {
        let findIdPwViewController = FindIdPwViewController()
        self.navigationController?.pushViewController(findIdPwViewController, animated: true)
    }

    @objc private func signUpButtonTapped() {
        let signUpFirstViewController = SignUpFirstViewController()
        self.navigationController?.pushViewController(signUpFirstViewController, animated: true)
    }

    @objc private func kakaoButtonTapped() {
        if UserApi.isKakaoTalkLoginAvailable() {
            loginWithApp()
        } else {
            loginWithWeb()
        }
    }

    @objc private func googleButtonTapped() {

    }

    @objc private func appleButtonTapped() {

    }
}

// MARK: - Kakao Social Login SubFunction
extension LoginViewController {
    func loginWithApp() {
        UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
            if let error = error {
                print(error)
            } else if let token = oauthToken {
                let newToken = Token(
                    accessToken: token.accessToken,
                    refreshToken: token.refreshToken,
                    accessExpiredAt: ISO8601DateFormatter().string(from: token.expiredAt),
                    refreshExpiredAt: ISO8601DateFormatter().string(from: token.refreshTokenExpiredAt)
                )
                TokenRepository().saveToken(with: newToken)
                self.fetchUserInfo()
                self.sendTokenToServer()
            }
        }
    }

    func loginWithWeb() {
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
            if let error = error {
                print("카카오 계정 로그인 실패: \(error.localizedDescription)")
            } else if let token = oauthToken {
                let newToken = Token(
                    accessToken: token.accessToken,
                    refreshToken: token.refreshToken,
                    accessExpiredAt: ISO8601DateFormatter().string(from: token.expiredAt),
                    refreshExpiredAt: ISO8601DateFormatter().string(from: token.refreshTokenExpiredAt)
                )
                TokenRepository().saveToken(with: newToken)
                self.fetchUserInfo()
                self.sendTokenToServer()
            }
        }
    }

    private func fetchUserInfo() {
        UserApi.shared.me { [weak self] (user, error) in
            if let error = error {
                print(error)
            } else {
                guard let nickname = user?.kakaoAccount?.profile?.nickname else { return }
                self?.presentToSignUpSecondViewController(with: nickname)
            }
        }
    }

    func presentToSignUpSecondViewController(with nickname: String) {
        let signUpSecondViewController = SignUpSecondViewController()
        signUpSecondViewController.signUpSecondView.nickNameTextField.text = nickname
        self.navigationController?.pushViewController(signUpSecondViewController, animated: true)
    }

    private func sendTokenToServer() {

    }
}

// MARK: - TextField Delegate Protocol
extension LoginViewController: UITextFieldDelegate {
    private func setupTextField() {
        loginView.idTextField.delegate = self
        loginView.pwTextField.delegate = self
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == loginView.idTextField {
            loginView.idTextField.backgroundColor = UIColor(resource: .popcornGray3)
        }
        if textField == loginView.pwTextField {
            loginView.pwTextField.backgroundColor = UIColor(resource: .popcornGray3)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == loginView.idTextField {
            loginView.idTextField.backgroundColor = UIColor(resource: .popcornGray4)
        }
        if textField == loginView.pwTextField {
            loginView.pwTextField.backgroundColor = UIColor(resource: .popcornGray4)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginView.idTextField {
            guard let idText = loginView.idTextField.text, !idText.isEmpty else { return false }
            loginView.pwTextField.becomeFirstResponder()
            return true
        }
        if textField == loginView.pwTextField {
            guard let idText = loginView.idTextField.text, !idText.isEmpty,
                  let passwordText = loginView.pwTextField.text, !passwordText.isEmpty else { return false }
            loginView.pwTextField.resignFirstResponder()
            loginView.loginButton.sendActions(for: .touchUpInside)
            return true
        }
       return false
    }
}
