//
//  LoginViewController.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/19/24.
//

import UIKit

class LoginViewController: UIViewController {
    private let loginView = LoginView()

    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupAddTarget()
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
        loginView.checkIdPwLabel.textColor = .red
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

    }

    @objc private func googleButtonTapped() {

    }

    @objc private func appleButtonTapped() {

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
