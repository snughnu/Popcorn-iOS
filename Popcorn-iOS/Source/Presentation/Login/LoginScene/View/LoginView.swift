//
//  LoginView.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/19/24.
//

import UIKit

final class LoginView: UIView {
    private var popcornImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login_popcorn")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    let idTextField = LoginTextField(
        placeholder: "아이디",
        keyboardType: .emailAddress
    )

    let passwordTextField = LoginTextField(
        placeholder: "비밀번호",
        keyboardType: .default,
        isSecureTextEntry: true
    )

    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.851, green: 0.851, blue: 0.851, alpha: 1.0)
        button.layer.cornerRadius = 10
        button.contentVerticalAlignment = .center
        button.isEnabled = false
        return button
    }()

    lazy var idPasswordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            idTextField,
            passwordTextField
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    let findButton: UIButton = {
        let button = UIButton()
        button.setTitle("아이디 / 비밀번호 찾기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .clear
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 1
        return button
    }()

    private let findSignUpSeparateView: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        view.heightAnchor.constraint(equalToConstant: 11).isActive = true
        view.backgroundColor = .lightGray
        return view
    }()

    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .clear
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 1
        return button
    }()

    lazy var findSignUpStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            findButton,
            findSignUpSeparateView,
            signUpButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private let leftSeparateView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .lightGray
        return view
    }()

    private let socialLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "SNS 계정으로 로그인"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        return label
    }()

    private let rightSeparateView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .lightGray
        return view
    }()

    lazy var separateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            leftSeparateView,
            socialLoginLabel,
            rightSeparateView
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()

    let kakaoButton: UIButton = {
        let button = UIButton()
        button.setTitle("카카오", for: UIControl.State.normal)
        button.setTitleColor(.lightGray, for: UIControl.State.normal)
        button.backgroundColor = .clear
        return button
    }()

    let googleButton: UIButton = {
        let button = UIButton()
        button.setTitle("구글", for: UIControl.State.normal)
        button.setTitleColor(.lightGray, for: UIControl.State.normal)
        button.backgroundColor = .clear
        return button
    }()

    let appleButton: UIButton = {
        let button = UIButton()
        button.setTitle("애플", for: UIControl.State.normal)
        button.setTitleColor(.lightGray, for: UIControl.State.normal)
        button.backgroundColor = .clear
        return button
    }()

    lazy var socialLoginStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            kakaoButton,
            googleButton,
            appleButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureInitialSetting()
        configureSubviews()
        configureLayout()
        configureTextFields()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure InitialSetting
extension LoginView {
    func configureInitialSetting() {
        backgroundColor = .white
    }
}

// MARK: - Configure TextFields
extension LoginView {
    func configureTextFields() {
        idTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}

// MARK: - Configure Layout
extension LoginView {
    private func configureSubviews() {
        [
            popcornImageView,
            idPasswordStackView,
            loginButton,
            findSignUpStackView,
            separateStackView,
            socialLoginStackView
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            popcornImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 126),
            popcornImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            popcornImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 81),

            idPasswordStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            idPasswordStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            idPasswordStackView.topAnchor.constraint(equalTo: popcornImageView.bottomAnchor, constant: 56),

            loginButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            loginButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            loginButton.topAnchor.constraint(equalTo: idPasswordStackView.bottomAnchor, constant: 27),
            loginButton.heightAnchor.constraint(equalTo: idTextField.heightAnchor, constant: 3),

            findSignUpStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 95),
            findSignUpStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -95),
            findSignUpStackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 28),

            separateStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 26),
            separateStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            separateStackView.topAnchor.constraint(equalTo: findSignUpStackView.bottomAnchor, constant: 60),

            socialLoginStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 116),
            socialLoginStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -116),
            socialLoginStackView.topAnchor.constraint(equalTo: separateStackView.bottomAnchor, constant: 26)
        ])
    }
}

// MARK: - LoginButton Active
extension LoginView {
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = " "
                return
            }
        }
        guard
            let id = idTextField.text, !id.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
            loginButton.backgroundColor = .lightGray
            loginButton.isEnabled = false
            return
        }
        loginButton.backgroundColor = #colorLiteral(red: 1.0, green: 0.384, blue: 0.004, alpha: 1.0)
        loginButton.isEnabled = true
    }
}
