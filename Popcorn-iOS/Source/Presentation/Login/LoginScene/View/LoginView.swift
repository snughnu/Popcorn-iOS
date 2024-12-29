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
        imageView.image = UIImage(resource: .logo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let idTextField = LoginTextField(
        placeholder: "아이디",
        keyboardType: .emailAddress
    )

    let pwTextField = LoginTextField(
        placeholder: "비밀번호",
        keyboardType: .default,
        isSecureTextEntry: true
    )

    let pwEyeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(resource: .loginPasswordEyeButton)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration = config
        return button
    }()

    let checkIdPwLabel: UILabel = {
        let label = UILabel()
        let text = "아이디 또는 비밀번호를 다시 확인하세요."
        label.textColor = UIColor(.white)
        let screenHeight = UIScreen.main.bounds.height
        let fontSize = screenHeight * 10/852
        label.font = UIFont(name: RobotoFontName.robotoMedium, size: fontSize)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 14
        let attributedText = NSAttributedString(string: text, attributes: [
            .paragraphStyle: paragraphStyle
        ])
        label.attributedText = attributedText
        return label
    }()

    lazy var loginButton: UIButton = {
        let button = UIButton()
        let screenHeight = UIScreen.main.bounds.height
        let fontSize = screenHeight * 15/852
        button.applyPopcornFont(text: "로그인", fontName: RobotoFontName.robotoSemiBold, fontSize: fontSize)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(resource: .popcornGray2)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        return button
    }()

    lazy var findButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        let screenHeight = UIScreen.main.bounds.height
        let fontSize = screenHeight * 15/852
        button.applyPopcornFont(text: "아이디 / 비밀번호 찾기", fontName: RobotoFontName.robotoMedium, fontSize: fontSize)
        button.backgroundColor = .clear
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 1
        return button
    }()

    private let findSignUpSeparateView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        let screenHeight = UIScreen.main.bounds.height
        let fontSize = screenHeight * 15/852
        button.applyPopcornFont(text: "회원가입", fontName: RobotoFontName.robotoMedium, fontSize: fontSize)
        button.backgroundColor = .clear
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 1
        return button
    }()

    private let leftSeparateView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    private lazy var socialLoginLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.popcornMedium(text: "SNS 계정으로 로그인", size: 11)
        return label
    }()

    private let rightSeparateView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    let kakaoButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(resource: .loginKakao)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration = config
        return button
    }()

    let googleButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(resource: .loginGoogle)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration = config
        return button
    }()

    let appleButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(resource: .loginApple)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration = config
        return button
    }()

    // MARK: - StackView
    lazy var idPwStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            idTextField,
            pwTextField
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 20/852
        stackView.spacing = size
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    lazy var findSignUpStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            findButton,
            findSignUpSeparateView,
            signUpButton
        ])
        stackView.axis = .horizontal
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 5/852
        stackView.spacing = size
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()

    lazy var loginContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            idPwStackView,
            checkIdPwLabel,
            loginButton
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 12/852
        stackView.spacing = size
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()

    lazy var loginFindSignUpContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            loginContentStackView,
            findSignUpStackView
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 18/852
        stackView.spacing = size
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()

    lazy var socialLoginSeparateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            leftSeparateView,
            socialLoginLabel,
            rightSeparateView
        ])
        stackView.axis = .horizontal
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 10/852
        stackView.spacing = size
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()

    lazy var socialLoginButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            kakaoButton,
            googleButton,
            appleButton
        ])
        stackView.axis = .horizontal
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 20/852
        stackView.spacing = size
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()

    lazy var socialLoginStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            socialLoginSeparateStackView,
            socialLoginButtonStackView
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 26/852
        stackView.spacing = size
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()

    lazy var entireStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            popcornImageView,
            loginFindSignUpContentStackView,
            socialLoginStackView
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 58/852
        stackView.spacing = size
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
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
        pwTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}

// MARK: - Configure Layout
extension LoginView {
    private func configureSubviews() {
        [
            entireStackView,
            pwEyeButton
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            entireStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            entireStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 81),

            popcornImageView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 87/759),
            popcornImageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 140/393),

            idTextField.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 50/759),
            idTextField.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 330/393),

            pwTextField.centerXAnchor.constraint(equalTo: idTextField.centerXAnchor),
            pwTextField.heightAnchor.constraint(equalTo: idTextField.heightAnchor),
            pwTextField.widthAnchor.constraint(equalTo: idTextField.widthAnchor),

            pwEyeButton.trailingAnchor.constraint(equalTo: pwTextField.trailingAnchor, constant: -20),
            pwEyeButton.centerYAnchor.constraint(equalTo: pwTextField.centerYAnchor),
            pwEyeButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 24/759),
            pwEyeButton.widthAnchor.constraint(equalTo: pwEyeButton.heightAnchor),

            checkIdPwLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 13/759),

            loginButton.centerXAnchor.constraint(equalTo: idTextField.centerXAnchor),
            loginButton.heightAnchor.constraint(equalTo: idTextField.heightAnchor, multiplier: 53/50),
            loginButton.widthAnchor.constraint(equalTo: idTextField.widthAnchor),

            findSignUpStackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 218/393),

            findSignUpSeparateView.widthAnchor.constraint(equalToConstant: 1),
            findSignUpSeparateView.heightAnchor.constraint(
                equalTo: safeAreaLayoutGuide.heightAnchor,
                multiplier: 11/759
            ),

            leftSeparateView.heightAnchor.constraint(equalToConstant: 1),
            rightSeparateView.heightAnchor.constraint(equalToConstant: 1),
            socialLoginLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 13/759),

            socialLoginSeparateStackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 341/393),

            socialLoginSeparateStackView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 40/759)
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
            let password = pwTextField.text, !password.isEmpty else {
            loginButton.backgroundColor = UIColor(resource: .popcornGray2)
            loginButton.isEnabled = false
            return
        }
        loginButton.backgroundColor = UIColor(resource: .popcornOrange)
        loginButton.isEnabled = true
    }
}
