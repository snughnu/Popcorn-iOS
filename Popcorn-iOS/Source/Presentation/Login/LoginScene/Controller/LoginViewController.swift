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
