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
            loginView.checkIdPwLabel.textColor = .red
            loginView.checkIdPwLabel.text = "아이디 또는 비밀번호를 입력해주세요."
            return
        }

        LoginManager.shared.login(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let loginData):
                    print("Login successful.")
                    print("Access Token: \(loginData.accessToken)")
                    print("Access Token Expiry: \(loginData.accessExpiredAt)")
                    print("Refresh Token: \(loginData.refreshToken)")
                    print("Refresh Token Expiry: \(loginData.refreshExpiredAt)")

                    let mainSceneViewController = MainSceneViewController()
                    self?.navigationController?.setViewControllers([mainSceneViewController], animated: true)

                case .failure(let error):
                    print("Login failed: \(error)")
                    self?.loginView.checkIdPwLabel.textColor = .red
                    self?.loginView.checkIdPwLabel.text = "아이디 또는 비밀번호를 다시 확인하세요."
                }
            }
        }
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
            } else {
                self.fetchUserInfo()
                self.sendTokenToServer()
            }
        }
    }

    func loginWithWeb() {
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
            if let error = error {
                print(error)
            } else {
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
