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
        imageView.image = UIImage(named: "login_popcornImage")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private var popcornLogoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login_popcornLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let emailTextField = LoginTextField(
        placeholder: "이메일",
        keyboardType: .emailAddress
    )

    private let passwordTextField = LoginTextField(
        placeholder: "비밀번호",
        keyboardType: .default,
        isSecureTextEntry: true
    )

    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.contentVerticalAlignment = .center
        button.isEnabled = false
        return button
    }()

    lazy var emailPasswordLoginStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            loginButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    let findButton: UIButton = {
        let button = UIButton()
        button.setTitle("아이디 /비밀번호 찾기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.backgroundColor = .clear
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 1.0
        button.titleLabel?.numberOfLines = 1
        return button
    }()

    private let findSignUpSeparateView: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        view.heightAnchor.constraint(equalToConstant: 15).isActive = true
        view.backgroundColor = .lightGray
        return view
    }()

    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.backgroundColor = .clear
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 1.0
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

    // MARK: - initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - setup
extension LoginView {
    func setup() {
        backgroundColor = .white
        configureSubviews()
        configureLayout()
        emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}

// MARK: - configure
extension LoginView {
    private func configureSubviews() {[
        popcornImageView,
        popcornLogoView,
        emailPasswordLoginStackView,
        findSignUpStackView,
        separateStackView,
        socialLoginStackView
    ].forEach {
        addSubview($0)
        $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        popcornImageViewConstraints()
        popcornLogoViewConstraints()
        emailPasswordLoginStackViewConstraints()
        findSignUpStackViewConstraints()
        separateStackViewConstraints()
        socialLoginStackViewConstraints()
    }

    private func popcornImageViewConstraints() {
        NSLayoutConstraint.activate([
            popcornImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 168),
            popcornImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            popcornImageView.widthAnchor.constraint(equalToConstant: 58),
            popcornImageView.heightAnchor.constraint(equalToConstant: 52),
            popcornImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 93)
        ])
    }

    private func popcornLogoViewConstraints() {
        NSLayoutConstraint.activate([
            popcornLogoView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 122),
            popcornLogoView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            popcornLogoView.widthAnchor.constraint(equalToConstant: 150),
            popcornLogoView.heightAnchor.constraint(equalToConstant: 45),
            popcornLogoView.topAnchor.constraint(equalTo: popcornImageView.bottomAnchor, constant: 3)
        ])
    }

    private func emailPasswordLoginStackViewConstraints() {
        NSLayoutConstraint.activate([
            emailPasswordLoginStackView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 32
            ),
            emailPasswordLoginStackView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -32
            ),
            emailPasswordLoginStackView.topAnchor.constraint(
                equalTo: popcornLogoView.bottomAnchor,
                constant: 32
            )
        ])
    }

    private func findSignUpStackViewConstraints() {
        NSLayoutConstraint.activate([
            findSignUpStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 96),
            findSignUpStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -96),
            findSignUpStackView.topAnchor.constraint(equalTo: emailPasswordLoginStackView.bottomAnchor, constant: 28)
        ])
    }

    private func separateStackViewConstraints() {
        NSLayoutConstraint.activate([
            separateStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 26),
            separateStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            separateStackView.topAnchor.constraint(equalTo: findSignUpStackView.bottomAnchor, constant: 60)
        ])
    }

    private func socialLoginStackViewConstraints() {
        NSLayoutConstraint.activate([
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
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
            loginButton.backgroundColor = .lightGray
            loginButton.isEnabled = false
            return
        }
        loginButton.backgroundColor = #colorLiteral(red: 1.0, green: 0.384, blue: 0.004, alpha: 1.0)
        loginButton.isEnabled = true
    }
}

// MARK: - textField delegate protocol
extension LoginView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailTextField.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        }
        if textField == passwordTextField {
            passwordTextField.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == emailTextField {
            emailTextField.backgroundColor = #colorLiteral(red: 0.969, green: 0.973, blue: 0.976, alpha: 1)
        }
        if textField == passwordTextField {
            passwordTextField.backgroundColor = #colorLiteral(red: 0.969, green: 0.973, blue: 0.976, alpha: 1)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
