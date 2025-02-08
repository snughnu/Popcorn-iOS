//
//  SignUpFirstViewController.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/24/24.
//

import UIKit

final class SignUpFirstViewController: UIViewController {
    // MARK: - Properties
    private let signUpFirstView = SignUpFirstView()
    private var signUpFirstViewModel: SignUpFirstViewModelProtocol
    private let screenHeight = UIScreen.main.bounds.height

    // MARK: - Initializer
    init(
        signUpFirstViewModel: SignUpFirstViewModelProtocol
    ) {
        self.signUpFirstViewModel = signUpFirstViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = signUpFirstView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: signUpFirstViewModel)
        setupAddActions()
        setupTextField()
        signUpFirstViewModel.setupKeyboardHandling(for: view)
        setupNavigationBar()
    }
}

// MARK: - Bind func
extension SignUpFirstViewController {
    private func bind(to signUpFirstViewModel: SignUpFirstViewModelProtocol) {

    }
}

// MARK: - Setup Actions
extension SignUpFirstViewController {
    private func setupAddActions() {
        signUpFirstView.duplicateCheckButton.addAction(UIAction { _ in
            self.duplicateCheckButtonTapped()
        }, for: .touchUpInside)

        signUpFirstView.requestAuthButton.addAction(UIAction { _ in
            self.requestAuthButtonTapped()
        }, for: .touchUpInside)

        signUpFirstView.nextButton.addAction(UIAction { _ in
            self.nextButtonTapped()
        }, for: .touchUpInside)
    }

    private func duplicateCheckButtonTapped() {
        guard let idText = signUpFirstView.idField.textFieldReference.text, !idText.isEmpty else {
            signUpFirstView.idField.labelReference.textColor = UIColor(.red)
            signUpFirstView.idField.labelReference.text = "*아이디를 입력해주세요."
            return
        }
        signUpFirstViewModel.checkUsernameAvailability(username: idText)
    }

    private func requestAuthButtonTapped() {
        guard let emailText = signUpFirstView.emailField.textFieldReference.text, !emailText.isEmpty else {
            signUpFirstView.emailField.labelReference.textColor = UIColor(.red)
            signUpFirstView.emailField.labelReference.text = "*이메일을 올바르게 입력해주세요."
            return
        }
        signUpFirstViewModel.requestVerificationCode(email: emailText)
    }

    private func nextButtonTapped() {
        guard let email = signUpFirstView.emailField.textFieldReference.text,
              let authNum = signUpFirstView.authNumberField.textFieldReference.text else {
            signUpFirstView.authNumberField.labelReference.textColor = UIColor(.red)
            signUpFirstView.authNumberField.labelReference.text = "*인증번호를 입력해주세요."
            return
        }
        signUpFirstViewModel.validateVerificationCode(email: email, authNum: authNum)
    }
}

// MARK: - Setup TextField
extension SignUpFirstViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func setupTextField() {
        [
            signUpFirstView.nameField.textFieldReference,
            signUpFirstView.idField.textFieldReference,
            signUpFirstView.passwordField.textFieldReference,
            signUpFirstView.confirmPasswordField.textFieldReference,
            signUpFirstView.emailField.textFieldReference,
            signUpFirstView.authNumberField.textFieldReference
        ].forEach {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        }
    }

    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if textField == signUpFirstView.nameField.textFieldReference {
            signUpFirstViewModel.updateName(textField.text ?? "")
        } else if textField == signUpFirstView.idField.textFieldReference {
            signUpFirstViewModel.updateId(textField.text ?? "")
        } else if textField == signUpFirstView.passwordField.textFieldReference {
            let confirmPassword = signUpFirstView.confirmPasswordField.textFieldReference.text ?? ""
            signUpFirstViewModel.updatePw(textField.text ?? "")
            signUpFirstViewModel.updateConfirmPw(textField.text ?? "", confirmPassword)
        } else if textField == signUpFirstView.confirmPasswordField.textFieldReference {
            let password = signUpFirstView.passwordField.textFieldReference.text ?? ""
            signUpFirstViewModel.updateConfirmPw(password, textField.text ?? "")
        } else if textField == signUpFirstView.emailField.textFieldReference {
            signUpFirstViewModel.updateEmail(textField.text ?? "")
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == signUpFirstView.nameField.textFieldReference {
            textField.backgroundColor = UIColor(resource: .popcornGray3)
        }
        if textField == signUpFirstView.idField.textFieldReference {
            textField.backgroundColor = UIColor(resource: .popcornGray3)
        }
        if textField == signUpFirstView.passwordField.textFieldReference {
            textField.backgroundColor = UIColor(resource: .popcornGray3)
        }
        if textField == signUpFirstView.confirmPasswordField.textFieldReference {
            textField.backgroundColor = UIColor(resource: .popcornGray3)
        }
        if textField == signUpFirstView.emailField.textFieldReference {
            textField.backgroundColor = UIColor(resource: .popcornGray3)
        }
        if textField == signUpFirstView.authNumberField.textFieldReference {
            textField.backgroundColor = UIColor(resource: .popcornGray3)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == signUpFirstView.nameField.textFieldReference {
            textField.backgroundColor = UIColor(resource: .popcornGray4)
        }
        if textField == signUpFirstView.idField.textFieldReference {
            textField.backgroundColor = UIColor(resource: .popcornGray4)
        }
        if textField == signUpFirstView.passwordField.textFieldReference {
            textField.backgroundColor = UIColor(resource: .popcornGray4)
        }
        if textField == signUpFirstView.confirmPasswordField.textFieldReference {
            textField.backgroundColor = UIColor(resource: .popcornGray4)
        }
        if textField == signUpFirstView.emailField.textFieldReference {
            textField.backgroundColor = UIColor(resource: .popcornGray4)
        }
        if textField == signUpFirstView.authNumberField.textFieldReference {
            textField.backgroundColor = UIColor(resource: .popcornGray4)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == signUpFirstView.nameField.textFieldReference {
            guard let nameText = signUpFirstView.nameField.textFieldReference.text,
                  !nameText.isEmpty else { return false }
            signUpFirstView.idField.textFieldReference.becomeFirstResponder()
            return true
        }
        if textField == signUpFirstView.idField.textFieldReference {
            guard let idText = signUpFirstView.idField.textFieldReference.text,
                  !idText.isEmpty else { return false }
            signUpFirstView.passwordField.textFieldReference.becomeFirstResponder()
            return true
        }
        if textField == signUpFirstView.passwordField.textFieldReference {
            guard let pwText = signUpFirstView.passwordField.textFieldReference.text,
                  !pwText.isEmpty else { return false }
            signUpFirstView.confirmPasswordField.textFieldReference.becomeFirstResponder()
            return true
        }
        if textField == signUpFirstView.confirmPasswordField.textFieldReference {
            guard let confirmPwText = signUpFirstView.confirmPasswordField.textFieldReference.text,
                  !confirmPwText.isEmpty else { return false }
            signUpFirstView.emailField.textFieldReference.becomeFirstResponder()
            return true
        }
        if textField == signUpFirstView.emailField.textFieldReference {
            guard let emailText = signUpFirstView.emailField.textFieldReference.text,
                  !emailText.isEmpty else { return false }
            signUpFirstView.authNumberField.textFieldReference.becomeFirstResponder()
            return true
        }
        return false
    }
}

// MARK: - Setup NavigationBar
extension SignUpFirstViewController {
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "회원가입"
        let size = screenHeight * 21/852
        titleLabel.font = UIFont(name: RobotoFontName.robotoSemiBold, size: size)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
        navigationItem.hidesBackButton = true
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(resource: .naviBackButton), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 20
        navigationItem.leftBarButtonItems = [spacer, leftBarButtonItem]
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
