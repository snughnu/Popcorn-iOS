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

    private var isNameValid = false
    private var isIdValid = false
    private var isPasswordValid = false
    private var isConfirmPasswordValid = false
    private var isEmailValid = false

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
            signUpFirstView.authNumberField.textFieldReference
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
                isIdValid = false
            } else {
                checkIdDuplication { [weak self] isDuplicate in
                    DispatchQueue.main.async {
                        if isDuplicate {
                            self?.signUpFirstView.idField.labelReference.textColor = UIColor(.red)
                            self?.signUpFirstView.idField.labelReference.text = "*중복된 아이디입니다."
                            self?.isIdValid = false
                        } else {
                            self?.signUpFirstView.idField.labelReference.textColor = UIColor(.blue)
                            self?.signUpFirstView.idField.labelReference.text = "*사용 가능한 아이디입니다."
                            self?.isIdValid = true
                        }
                    }
                }
            }
        } else {
            signUpFirstView.idField.labelReference.textColor = UIColor(.red)
            signUpFirstView.idField.labelReference.text = "*6~12자의 영문과 숫자의 조합으로 입력해주세요."
            isIdValid = false
        }
    }

    private func requestAuthButtonTapped() {
        guard let emailText = signUpFirstView.emailField.textFieldReference.text, !emailText.isEmpty else {
            signUpFirstView.emailField.labelReference.textColor = UIColor(.red)
            signUpFirstView.emailField.labelReference.text = "*이메일을 올바르게 입력해주세요."
            return
        }

        signUpFirstView.emailField.labelReference.textColor = UIColor(.blue)
        signUpFirstView.emailField.labelReference.text = "전송 중입니다..."

        SignupDataManager.shared.sendVerificationCode(email: emailText) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.signUpFirstView.emailField.labelReference.textColor = UIColor(.blue)
                    self?.signUpFirstView.emailField.labelReference.text = "*인증번호가 발송되었습니다."
                    self?.isEmailValid = true
                case .failure:
                    self?.signUpFirstView.emailField.labelReference.textColor = UIColor(.red)
                    self?.signUpFirstView.emailField.labelReference.text = "*인증번호 발송 실패."
                    self?.isEmailValid = false
                }
            }
        }
    }

    private func nextButtonTapped() {
        if isNameValid, isIdValid, isPasswordValid, isConfirmPasswordValid, isEmailValid {
            validateAuthNumber { [weak self] isValid in
                DispatchQueue.main.async {
                    if isValid {
                        self?.saveSignupData()
                        let secondVC = SignUpSecondViewController()
                        self?.navigationController?.pushViewController(secondVC, animated: true)
                    } else {
                        self?.signUpFirstView.authNumberField.labelReference.textColor = UIColor(.red)
                        self?.signUpFirstView.authNumberField.labelReference.text = "*인증번호가 올바르지 않습니다."
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.signUpFirstView.authNumberField.labelReference.textColor = UIColor(.red)
                self.signUpFirstView.authNumberField.labelReference.text = "*개인정보를 먼저 입력해주세요."
            }
        }
    }

    private func validateAuthNumber(completion: @escaping (Bool) -> Void) {
        guard let authNum = signUpFirstView.authNumberField.textFieldReference.text else {
            completion(false)
            return
        }
        SignupDataManager.shared.verifyAuthCode(email: signUpFirstView.emailField.textFieldReference.text!,
                                                authNum: authNum) { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
}

// MARK: - Validate and Save Methods
extension SignUpFirstViewController {
    private func validateNameField() {
        if let nameText = signUpFirstView.nameField.textFieldReference.text, !nameText.isEmpty {
            if !isValidName(nameText) {
                signUpFirstView.nameField.labelReference.textColor = UIColor(.red)
                signUpFirstView.nameField.labelReference.text = "*이름을 올바르게 입력해주세요."
                isNameValid = false
            } else {
                signUpFirstView.nameField.labelReference.textColor = UIColor(.blue)
                signUpFirstView.nameField.labelReference.text = " "
                isNameValid = true
            }
        } else {
            signUpFirstView.nameField.labelReference.textColor = UIColor(.red)
            signUpFirstView.nameField.labelReference.text = "*이름을 입력해주세요."
            isNameValid = false
        }
    }

    private func validatePasswordField() {
        if let passwordText = signUpFirstView.passwordField.textFieldReference.text, !passwordText.isEmpty {
            if !isValidPassword(passwordText) {
                signUpFirstView.passwordField.labelReference.textColor = UIColor(.red)
                signUpFirstView.passwordField.labelReference.text = "*8~16자, 영문, 숫자, 특수문자를 조합해주세요."
                isPasswordValid = false
            } else {
                signUpFirstView.passwordField.labelReference.textColor = UIColor(.blue)
                signUpFirstView.passwordField.labelReference.text = "*사용 가능한 비밀번호입니다."
                isPasswordValid = true
            }
        } else {
            signUpFirstView.passwordField.labelReference.textColor = UIColor(.red)
            signUpFirstView.passwordField.labelReference.text = "*비밀번호를 입력해주세요."
            isPasswordValid = false
        }
    }

    private func validateConfirmPasswordField() {
        guard let passwordText = signUpFirstView.passwordField.textFieldReference.text,
              let confirmPasswordText = signUpFirstView.confirmPasswordField.textFieldReference.text else {
            isConfirmPasswordValid = false
            return
        }

        if confirmPasswordText.isEmpty {
            signUpFirstView.confirmPasswordField.labelReference.textColor = UIColor(.red)
            signUpFirstView.confirmPasswordField.labelReference.text = "*비밀번호 확인을 입력해주세요."
            isConfirmPasswordValid = false
        } else if confirmPasswordText != passwordText {
            signUpFirstView.confirmPasswordField.labelReference.textColor = UIColor(.red)
            signUpFirstView.confirmPasswordField.labelReference.text = "*비밀번호가 일치하지 않습니다."
            isConfirmPasswordValid = false
        } else {
            signUpFirstView.confirmPasswordField.labelReference.textColor = UIColor(.blue)
            signUpFirstView.confirmPasswordField.labelReference.text = "*비밀번호가 일치합니다."
            isConfirmPasswordValid = true
        }
    }

    private func saveSignupData() {
        guard let name = signUpFirstView.nameField.textFieldReference.text,
              let id = signUpFirstView.idField.textFieldReference.text,
              let password = signUpFirstView.passwordField.textFieldReference.text,
              let email = signUpFirstView.emailField.textFieldReference.text else { return }

        let data = SignUpData(
            firstSignUpDto: SignUpData.FirstSignUpDto(username: id, password: password, name: name, email: email),
            secondSignUpDto: nil
        )

        do {
            let jsonData = try JSONEncoder().encode(data)
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "signupData",
                kSecValueData as String: jsonData
            ]

            let keychainManager = KeychainManager()
            let status = keychainManager.addItem(with: query)

            if status == errSecDuplicateItem {
                let updateQuery: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: "signupData"
                ]
                let updateAttributes: [String: Any] = [
                    kSecValueData as String: jsonData
                ]
                keychainManager.updateItem(with: updateQuery, as: updateAttributes)
                print("키체인 데이터 업데이트 성공")
            } else if status != errSecSuccess {
                print("키체인에 데이터 저장 실패: \(status)")
            } else {
                print("키체인에 데이터 저장 성공")
            }
        } catch {
            print("데이터 인코딩 실패: \(error)")
        }
    }
}

// MARK: - 서브함수 - 정규식
extension SignUpFirstViewController {
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

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*?&#])[A-Za-z\\d@$!%*?&#]{8,16}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}
