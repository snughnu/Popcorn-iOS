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

    func setupAddTarget() {
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginView.findButton.addTarget(self, action: #selector(findButtonTapped), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        loginView.kakaoButton.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
        loginView.googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        loginView.appleButton.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
    }

    @objc func loginButtonTapped() {

    }

    @objc func findButtonTapped() {

    }

    @objc func signUpButtonTapped() {

    }

    @objc func kakaoButtonTapped() {

    }

    @objc func googleButtonTapped() {

    }

    @objc func appleButtonTapped() {

    }
}

// MARK: - textField delegate protocol
extension LoginViewController: UITextFieldDelegate {
    private func setupTextField() {
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == loginView.emailTextField {
            loginView.emailTextField.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        }
        if textField == loginView.passwordTextField {
            loginView.passwordTextField.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == loginView.emailTextField {
            loginView.emailTextField.backgroundColor = #colorLiteral(red: 0.969, green: 0.973, blue: 0.976, alpha: 1)
        }
        if textField == loginView.passwordTextField {
            loginView.passwordTextField.backgroundColor = #colorLiteral(red: 0.969, green: 0.973, blue: 0.976, alpha: 1)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginView.emailTextField {
            guard let emailText = loginView.emailTextField.text, !emailText.isEmpty else { return false }
            loginView.passwordTextField.becomeFirstResponder()
            return true
        }
        if textField == loginView.passwordTextField {
            guard let emailText = loginView.emailTextField.text, !emailText.isEmpty,
                  let passwordText = loginView.passwordTextField.text, !passwordText.isEmpty else { return false }
            loginView.passwordTextField.resignFirstResponder()
            loginView.loginButton.sendActions(for: .touchUpInside)
            return true
        }
       return false
    }
}
