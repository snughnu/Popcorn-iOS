//
//  SignUpFirstViewController.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/24/24.
//

import UIKit

class SignUpFirstViewController: UIViewController {
    private let signUpFirstView = SignUpFirstView()

    override func loadView() {
        view = signUpFirstView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTextField()
        setUpKeyboard()
        setupAddActions()
    }
}

// MARK: - Setup NavigationBar
extension SignUpFirstViewController {
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(resource: .naviBackButton), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        let titleLabel = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.11
        titleLabel.text = "회원가입"
        titleLabel.font = UIFont(name: RobotoFontName.robotoSemiBold, size: 21)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center

        view.addSubview(backButton)
        view.addSubview(titleLabel)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),

            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 157),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 23)
        ])
    }

    @objc private func backButtonTapped() {
       navigationController?.popViewController(animated: true)
    }
}

// MARK: - TextField Delegate Protocol
extension SignUpFirstViewController: UITextFieldDelegate {
    private func setupTextField() {
        [
            signUpFirstView.nameField.textFieldReference,
            signUpFirstView.idField.textFieldReference,
            signUpFirstView.passwordField.textFieldReference,
            signUpFirstView.confirmPasswordField.textFieldReference,
            signUpFirstView.emailTextField,
            signUpFirstView.authNumberTextField
        ].forEach {
            $0.delegate = self
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
        if textField == signUpFirstView.emailTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray3)
        }
        if textField == signUpFirstView.authNumberTextField {
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
        if textField == signUpFirstView.emailTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray4)
        }
        if textField == signUpFirstView.authNumberTextField {
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
            signUpFirstView.emailTextField.becomeFirstResponder()
            return true
        }
        if textField == signUpFirstView.emailTextField {
            guard let emailText = signUpFirstView.emailTextField.text,
                  !emailText.isEmpty else { return false }
            signUpFirstView.emailTextField.resignFirstResponder()
            self.requestAuthButtonTapped()
            return true
        }
        return false
    }
}

// MARK: - 현재 응답받는 UI
extension UIResponder {
    private struct Static {
        static weak var responder: UIResponder?
    }
    static var currentResponder: UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }
    @objc private func _trap() {
        Static.responder = self
    }
}

// MARK: - Setup Keyboard
extension SignUpFirstViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func setUpKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc func keyboardWillShow(_ sender: Notification) {
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentResponder as? UITextField else { return }

        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height

        if textFieldBottomY > keyboardTopY {
            let textFieldTopY = convertedTextFieldFrame.origin.y
            let newFrame = textFieldTopY - keyboardTopY/1.6
            view.frame.origin.y = -newFrame
        }
    }

    @objc func keyboardWillHide(_ sender: Notification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
}

// MARK: - Setup AddActions
extension SignUpFirstViewController {
    func setupAddActions() {
        signUpFirstView.requestAuthButton.addAction(UIAction { _ in
            self.requestAuthButtonTapped()
        }, for: .touchUpInside)

        signUpFirstView.nextButton.addAction(UIAction { _ in
            self.nextButtonTapped()
        }, for: .touchUpInside)
    }

    @objc func requestAuthButtonTapped() {
        // TODO: 서버와 통신
    }

    @objc func nextButtonTapped() {
        // TODO: SignUpSecondViewController 연결
    }
}
