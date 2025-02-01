//
//  LoginViewController.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/19/24.
//

import KakaoSDKUser
import UIKit

final class LoginViewController: UIViewController {
    // MARK: - Properties
    private let loginView = LoginView()
    private let loginViewModel: LoginViewModel
    private let socialLoginViewModel: SocialLoginViewModel

    // MARK: - Initializer
    init() {
        let networkManager = NetworkManager()
        let tokenRepository = TokenRepository(networkManager: networkManager)
        let loginRepository = LoginRepository(networkManager: networkManager)
        let loginUseCase = LoginUseCase(loginRepository: loginRepository, tokenRepository: tokenRepository)
        let socialLoginRepository = SocialLoginRepository()
        let socialLoginUseCase = SocialLoginUseCase(socialLoginRepository: socialLoginRepository, tokenRepository: tokenRepository)

        self.loginViewModel = LoginViewModel(loginUseCase: loginUseCase)
        self.socialLoginViewModel = SocialLoginViewModel(socialLoginUseCase: socialLoginUseCase)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: loginViewModel)
        bind(to: socialLoginViewModel)
        setupAddTarget()
        setupTextField()
    }
}

// MARK: - Bind func
extension LoginViewController {
    private func bind(to loginViewModel: LoginViewModel) {
        loginViewModel.loginButtonEnabledHandler = { [weak self] isEnabled in
            guard let self = self else { return }
            self.loginView.loginButton.backgroundColor = isEnabled
            ? UIColor(resource: .popcornOrange)
            : UIColor(resource: .popcornGray2)
            self.loginView.loginButton.isEnabled = isEnabled
        }

        loginViewModel.loginSuccessHandler = { [weak self] in
            guard let self = self else { return }
            let mainSceneViewController = MainSceneViewController()
            self.navigationController?.setViewControllers([mainSceneViewController], animated: true)
        }

        loginViewModel.loginFailHandler = { [weak self] message in
            guard let self = self else { return }
            self.loginView.checkIdPwLabel.textColor = .red
            self.loginView.checkIdPwLabel.text = message
        }
    }

    private func bind(to socialLoginViewModel: SocialLoginViewModel) {
        socialLoginViewModel.loginSuccessHandler = { [weak self] nickname in
            guard let self = self else { return }
            let signUpSecondViewController = SignUpSecondViewController()
            signUpSecondViewController.signUpSecondView.nickNameTextField.text = nickname
            self.navigationController?.pushViewController(signUpSecondViewController, animated: true)
        }

        socialLoginViewModel.loginFailHandler = { error in
            print("소셜 로그인 실패: \(error.localizedDescription)")
        }
    }
}

// MARK: - Configure AddTarget
extension LoginViewController {
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
        loginViewModel.login()
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
        socialLoginViewModel.loginWithKakao()
    }

    @objc private func googleButtonTapped() {

    }

    @objc private func appleButtonTapped() {

    }
}

// MARK: - Configure TextField
extension LoginViewController: UITextFieldDelegate {
    private func setupTextField() {
        loginView.idTextField.delegate = self
        loginView.pwTextField.delegate = self
        loginView.idTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        loginView.pwTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }

    @objc func textFieldEditingChanged(_ textField: UITextField) {
        if textField == loginView.idTextField {
            loginViewModel.updateUsername(textField.text ?? "")
        } else if textField == loginView.pwTextField {
            loginViewModel.updatePassword(textField.text ?? "")
        }
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        loginView.endEditing(true)
    }
}
