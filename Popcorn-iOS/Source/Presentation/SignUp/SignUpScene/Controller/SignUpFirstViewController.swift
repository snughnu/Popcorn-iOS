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
            if idText.isEmpty {
                signUpFirstView.idField.labelReference.textColor = UIColor(.red)
                signUpFirstView.idField.labelReference.text = "*6~12자의 영문과 숫자의 조합으로 입력해주세요."
            } else if !isValidId(idText) {
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
        if signUpFirstView.emailField.textFieldReference.text?.isEmpty ?? true {
            signUpFirstView.emailField.labelReference.textColor = UIColor(.red)
        }
        // TODO: 서버와 통신
    }

    private func nextButtonTapped() {
        let signUpSecondViewController = SignUpSecondViewController()
        self.navigationController?.pushViewController(signUpSecondViewController, animated: true)
    }
}

// MARK: - 서브함수 - 정규식
extension SignUpFirstViewController {
    private func isValidId(_ id: String) -> Bool {
        let idRegex = "^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]{6,12}$"
        let idTest = NSPredicate(format: "SELF MATCHES %@", idRegex)
        return idTest.evaluate(with: id)
    }

    private func checkIdDuplication(completion: @escaping (Bool) -> Void) {
        // TODO: 서버와 통신: 아이디 중복 여부를 확인하는 로직
        completion(false)
    }
}
