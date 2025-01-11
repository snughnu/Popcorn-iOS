//
//  SignUpFirstViewController.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/24/24.
//

import UIKit

class SignUpFirstViewController: UIViewController {
    private let signUpFirstView = SignUpFirstView()
    private let screenHeight = UIScreen.main.bounds.height

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

// MARK: - TextField Delegate Protocol
extension SignUpFirstViewController: UITextFieldDelegate {
    private func setupTextField() {
        [
            signUpFirstView.nameField.textFieldReference,
            signUpFirstView.idField.textFieldReference,
            signUpFirstView.passwordField.textFieldReference,
            signUpFirstView.confirmPasswordField.textFieldReference,
            signUpFirstView.emailField.textFieldReference,
            signUpFirstView.authNumberTextField
        ].forEach {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        }
    }

    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if textField == signUpFirstView.nameField.textFieldReference {
            validateNameField()
        } else if textField == signUpFirstView.passwordField.textFieldReference {
            validatePasswordField()
        } else if textField == signUpFirstView.confirmPasswordField.textFieldReference {
            validateConfirmPasswordField()
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
        if textField == signUpFirstView.emailField {
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
        if textField == signUpFirstView.emailField {
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
            signUpFirstView.emailField.becomeFirstResponder()
            return true
        }
        if textField == signUpFirstView.emailField.textFieldReference {
            guard let emailText = signUpFirstView.emailField.textFieldReference.text,
                  !emailText.isEmpty else { return false }
            signUpFirstView.emailField.becomeFirstResponder()
            return true
        }
        return false
    }
}

// MARK: - Setup Keyboard
extension SignUpFirstViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func setUpKeyboard() {
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
}

// MARK: - selector 함수
extension SignUpFirstViewController {
    private func duplicateCheckButtonTapped() {
        if let idText = signUpFirstView.idField.textFieldReference.text, !idText.isEmpty {
            if !isValidId(idText) {
                signUpFirstView.idField.labelReference.textColor = UIColor(.red)
                signUpFirstView.idField.labelReference.text = "*6~12자의 영문과 숫자의 조합으로 입력해주세요."
            } else {
                checkIdDuplication { [weak self] isDuplicate in
                    DispatchQueue.main.async {
                        if isDuplicate {
                            self?.signUpFirstView.idField.labelReference.textColor = UIColor(.red)
                            self?.signUpFirstView.idField.labelReference.text = "*중복된 아이디입니다."
                        } else {
                            self?.signUpFirstView.idField.labelReference.textColor = UIColor(.blue)
                            self?.signUpFirstView.idField.labelReference.text = "*사용 가능한 아이디입니다."
                        }
                    }
                }
            }
        } else {
            signUpFirstView.idField.labelReference.textColor = UIColor(.red)
            signUpFirstView.idField.labelReference.text = "*6~12자의 영문과 숫자의 조합으로 입력해주세요."
        }
    }

    private func requestAuthButtonTapped() {
        if let emailText = signUpFirstView.emailField.textFieldReference.text, !emailText.isEmpty {
            if !isValidEmail(emailText) {
                signUpFirstView.emailField.labelReference.textColor = UIColor(.red)
                signUpFirstView.emailField.labelReference.text = "*이메일을 올바르게 입력해주세요."
            } else {
                signUpFirstView.emailField.labelReference.text = ""
                requestEmailVerification(for: emailText) { [weak self] success in
                        DispatchQueue.main.async {
                            if success {
                                self?.signUpFirstView.emailField.labelReference.textColor = UIColor(.blue)
                                self?.signUpFirstView.emailField.labelReference.text = "*인증번호가 발송되었습니다."
                            } else {
                                self?.signUpFirstView.emailField.labelReference.textColor = UIColor(.red)
                                self?.signUpFirstView.emailField.labelReference.text = "*인증번호 발송에 실패했습니다. 다시 시도해주세요."
                            }
                        }
                    }
            }
        } else {
            signUpFirstView.emailField.labelReference.textColor = UIColor(.red)
            signUpFirstView.emailField.labelReference.text = "*이메일을 입력해주세요."
        }
    }

    private func nextButtonTapped() {
        let signUpSecondViewController = SignUpSecondViewController()
        self.navigationController?.pushViewController(signUpSecondViewController, animated: true)
    }
}

// MARK: - 서브함수 - 정규식
extension SignUpFirstViewController {
    private func validateNameField() {
        if let nameText = signUpFirstView.nameField.textFieldReference.text, !nameText.isEmpty {
            if !isValidName(nameText) {
                signUpFirstView.nameField.labelReference.textColor = UIColor(.red)
                signUpFirstView.nameField.labelReference.text = "*이름을 올바르게 입력해주세요."
            } else {
                signUpFirstView.nameField.labelReference.text = " "
            }
        } else {
            signUpFirstView.nameField.labelReference.textColor = UIColor(.red)
            signUpFirstView.nameField.labelReference.text = "*이름을 입력해주세요."
        }
    }

    private func isValidName(_ name: String) -> Bool {
        let nameRegex = "^[가-힣a-zA-Z]{2,10}$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: name)
    }

    private func isValidId(_ id: String) -> Bool {
        let idRegex = "^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]{6,12}$"
        let idTest = NSPredicate(format: "SELF MATCHES %@", idRegex)
        return idTest.evaluate(with: id)
    }

    private func checkIdDuplication(completion: @escaping (Bool) -> Void) {
        // TODO: 서버와 통신: 아이디 중복 여부를 확인하는 로직
        completion(false)
    }

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*?&#])[A-Za-z\\d@$!%*?&#]{8,16}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    private func validatePasswordField() {
        if let passwordText = signUpFirstView.passwordField.textFieldReference.text, !passwordText.isEmpty {
            if !isValidPassword(passwordText) {
                signUpFirstView.passwordField.labelReference.textColor = UIColor(.red)
                signUpFirstView.passwordField.labelReference.text = "*8~16자, 영문, 숫자, 특수문자를 조합해주세요."
            } else {
                signUpFirstView.passwordField.labelReference.textColor = UIColor(.blue)
                signUpFirstView.passwordField.labelReference.text = "*사용 가능한 비밀번호입니다."
            }
        } else {
            signUpFirstView.passwordField.labelReference.textColor = UIColor(.red)
            signUpFirstView.passwordField.labelReference.text = "*비밀번호를 입력해주세요."
        }
    }

    private func validateConfirmPasswordField() {
        guard let passwordText = signUpFirstView.passwordField.textFieldReference.text,
              let confirmPasswordText = signUpFirstView.confirmPasswordField.textFieldReference.text else { return }

        if confirmPasswordText.isEmpty {
            signUpFirstView.confirmPasswordField.labelReference.textColor = UIColor(.red)
            signUpFirstView.confirmPasswordField.labelReference.text = "*비밀번호 확인을 입력해주세요."
        } else if confirmPasswordText != passwordText {
            signUpFirstView.confirmPasswordField.labelReference.textColor = UIColor(.red)
            signUpFirstView.confirmPasswordField.labelReference.text = "*비밀번호가 일치하지 않습니다."
        } else {
            signUpFirstView.confirmPasswordField.labelReference.textColor = UIColor(.blue)
            signUpFirstView.confirmPasswordField.labelReference.text = "*비밀번호가 일치합니다."
        }
    }

    private func requestEmailVerification(for email: String, completion: @escaping (Bool) -> Void) {
        // TODO: 서버와 통신: email 변수를 서버에 전달, 성공/실패 결과를 completion으로 반환
        completion(false)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}
