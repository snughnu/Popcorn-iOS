//
//  SignUpFirstViewModel.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/4/25.
//

import Foundation
import UIKit.UIColor

protocol SignUpFirstViewModelProtocol {
    var nameMessageHandler: ((String, UIColor) -> Void)? { get set }
    var idMessageHandler: ((String, UIColor) -> Void)? { get set }
    var pwMessageHandler: ((String, UIColor) -> Void)? { get set }
    var confirmPwMessageHandler: ((String, UIColor) -> Void)? { get set }
    var emailMessageHandler: ((String, UIColor) -> Void)? { get set }
    var authNumMessageHandler: ((String, UIColor) -> Void)? { get set }
    var allFieldsValidHandler: ((Bool) -> Void)? { get set }
    var navigateToSignUpSecondHandler: (() -> Void)? { get set }

    func updateName(_ name: String)
    func updateId(_ id: String)
    func updatePw(_ pw: String)
    func updateConfirmPw(_ pw: String, _ confirmPw: String)
    func updateEmail(_ email: String)
    func updateAuthNum(_ authNum: String)
    func checkUsernameAvailability(username: String)
    func requestAuthNum(email: String)
    func validateAuthNum(email: String, authNum: String)

    func setupKeyboardHandling(for view: UIView)
}

final class SignUpFirstViewModel: SignUpFirstViewModelProtocol {
    // MARK: - Properties
    private let signUpUseCase: SignUpUseCaseProtocol
    private let keychainManager: KeychainManagerProtocol
    private weak var rootView: UIView?

    // MARK: - 입력값 검사
    private var name: String = "" {
        didSet {
            isNameValid = isNameFormatted(name)
            let message = isNameValid ? " " : "*이름을 올바르게 입력해주세요."
            let color = isNameValid ? UIColor(.blue) : UIColor(.red)
            nameMessageHandler?(message, color)
        }
    }

    private var id: String = "" {
        didSet {
            isIdValid = isIdFormatted(id)
            let message = isIdValid ? " " : "*6~12자의 영문과 숫자의 조합으로 입력해주세요."
            let color = isIdValid ? UIColor(.blue) : UIColor(.red)
            idMessageHandler?(message, color)
        }
    }

    private var pw: String = "" {
        didSet {
            isPwValid = isPwFormatted(pw)
            let message = isPwValid ? "*사용 가능한 비밀번호 입니다." : "*8~16자, 영문, 숫자, 특수문자를 조합해주세요."
            let color = isPwValid ? UIColor(.blue) : UIColor(.red)
            pwMessageHandler?(message, color)
        }
    }

    private var confirmPw: String = "" {
        didSet {
            isConfirmPwValid = isConfirmPwFormatted(pw, confirmPw)
            let message = isConfirmPwValid ? "*비밀번호가 일치합니다." : "*비밀번호가 일치하지 않습니다."
            let color = isConfirmPwValid ? UIColor(.blue) : UIColor(.red)
            confirmPwMessageHandler?(message, color)
        }
    }

    private var email: String = "" {
        didSet {
            isEmailValid = isEmailFormatted(email)
            let message = isEmailValid ? " " : "*이메일을 올바르게 입력해주세요."
            let color = isEmailValid ? UIColor(.blue) : UIColor(.red)
            emailMessageHandler?(message, color)
        }
    }

    // MARK: - 입력값 검사 상태
    private var isNameValid = false {
        didSet { updateAllFieldsValid() }
    }

    private var isIdValid = false {
        didSet { updateAllFieldsValid() }
    }

    private var isIdFormattedValid = false {
        didSet { updateAllFieldsValid() }
    }

    private var isPwValid = false {
        didSet { updateAllFieldsValid() }
    }

    private var isConfirmPwValid = false {
        didSet { updateAllFieldsValid() }
    }

    private var isEmailValid = false {
        didSet { updateAllFieldsValid() }
    }

    private var isAuthNumValid = false {
        didSet { updateAllFieldsValid() }
    }

    private var isAllValid = false {
        didSet { allFieldsValidHandler?(isAllValid) }
    }

    // MARK: - Output
    var nameMessageHandler: ((String, UIColor) -> Void)?
    var idMessageHandler: ((String, UIColor) -> Void)?
    var pwMessageHandler: ((String, UIColor) -> Void)?
    var confirmPwMessageHandler: ((String, UIColor) -> Void)?
    var emailMessageHandler: ((String, UIColor) -> Void)?
    var authNumMessageHandler: ((String, UIColor) -> Void)?
    var allFieldsValidHandler: ((Bool) -> Void)?
    var navigateToSignUpSecondHandler: (() -> Void)?

    // MARK: - Initializer
    init(
        signUpUseCase: SignUpUseCaseProtocol,
        keychainManager: KeychainManagerProtocol
    ) {
        self.signUpUseCase = signUpUseCase
        self.keychainManager = keychainManager
    }
}

// MARK: - 유효성 검사 (Validation)
extension SignUpFirstViewModel {
    private func isNameFormatted(_ name: String) -> Bool {
        let nameRegex = "^[가-힣a-zA-Z]{2,10}$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: name)
    }

    private func isIdFormatted(_ id: String) -> Bool {
        let idRegex = "^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]{6,12}$"
        let idTest = NSPredicate(format: "SELF MATCHES %@", idRegex)
        return idTest.evaluate(with: id)
    }

    private func isPwFormatted(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*?&#])[A-Za-z\\d@$!%*?&#]{8,16}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    private func isConfirmPwFormatted(_ password: String, _ confirmPassword: String) -> Bool {
        let pw = password
        let confirmPw = confirmPassword
        return (pw == confirmPw)
    }

    private func isEmailFormatted(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }

    private func updateAllFieldsValid() {
        isAllValid = isNameValid && isIdValid && isPwValid && isConfirmPwValid && isEmailValid && isAuthNumValid
    }
}

// MARK: - Public interface
extension SignUpFirstViewModel {
    func updateName(_ name: String) {
        self.name = name
    }

    func updateId(_ id: String) {
        self.id = id
        isIdFormattedValid = isIdFormatted(id)
        isIdValid = false
    }

    func updatePw(_ pw: String) {
        self.pw = pw
    }

    func updateConfirmPw(_ confirmPw: String) {
        self.confirmPw = confirmPw
    }

    func updateConfirmPw(_ pw: String, _ confirmPw: String) {
        self.pw = pw
        self.confirmPw = confirmPw
    }

    func updateEmail(_ email: String) {
        self.email = email
    }

    func updateAuthNum(_ authNum: String) {
        isAuthNumValid = !authNum.isEmpty
    }

    func checkUsernameAvailability(username: String) {
        guard isIdFormattedValid else {
            idMessageHandler?("*6~12자의 영문과 숫자의 조합으로 입력해주세요.", UIColor(.red))
            return
        }
        signUpUseCase.executeUsernameDuplicationCheck(username: username) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isAvailable):
                    self?.isIdValid = isAvailable
                    let message = isAvailable ? "*사용 가능한 아이디입니다." : "*중복된 아이디입니다."
                    let color = isAvailable ? UIColor(.blue) : UIColor(.red)
                    self?.idMessageHandler?(message, color)
                case .failure:
                    self?.idMessageHandler?("*아이디 중복 확인 실패.", UIColor(.red))
                }
            }
        }
    }

    func requestAuthNum(email: String) {
        guard isEmailValid else {
            emailMessageHandler?("*이메일을 올바르게 입력해주세요.", UIColor(.red))
            return
        }
        signUpUseCase.executeSendVerificationCode(email: email) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isSuccess):
                    let message = isSuccess ? "*인증번호가 발송되었습니다." : "*인증번호 전송 실패."
                    let color = isSuccess ? UIColor(.blue) : UIColor(.red)
                    self?.emailMessageHandler?(message, color)
                case .failure:
                    self?.emailMessageHandler?("*네트워크 오류.", UIColor(.red))
                }
            }
        }
    }

    func validateAuthNum(email: String, authNum: String) {
        guard isAllValid else {
            authNumMessageHandler?("*모든 정보를 올바르게 입력해주세요.", UIColor(.red))
            return
        }
        signUpUseCase.executeValidateVerificationCode(email: email, authNum: authNum) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let isSuccess):
                    if isSuccess {
                        let isSaved = self.saveSignUpData(
                            name: self.name,
                            id: self.id,
                            password: self.pw,
                            email: self.email
                        )
                        if isSaved {
                            self.navigateToSignUpSecondHandler?()
                        } else {
                            self.authNumMessageHandler?("*데이터 저장에 실패했습니다.", UIColor(.red))
                        }
                    } else {
                        self.authNumMessageHandler?("*인증번호가 올바르지 않습니다.", UIColor(.red))
                    }
                case .failure:
                    self.authNumMessageHandler?("*네트워크 오류가 발생했습니다.", UIColor(.red))
                }
            }
        }
    }

    private func saveSignUpData(name: String, id: String, password: String, email: String) -> Bool {
        let data = SignUpRequestDTO(
            firstSignupDto: FirstSignupDto(name: name, username: id, password: password, email: email),
            secondSignupDto: nil
        )

        do {
            let jsonData = try JSONEncoder().encode(data)
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "signupData"
            ]
            let attributes: [String: Any] = [
                kSecValueData as String: jsonData
            ]

            let status = keychainManager.updateItem(with: query, as: attributes)

            if status == errSecItemNotFound {
                let addQuery = query.merging(attributes) { _, new in new }
                let addStatus = keychainManager.addItem(with: addQuery)
                return addStatus == errSecSuccess
            } else if status == errSecSuccess {
                return true
            }
        } catch {
            print("데이터 인코딩 실패: \(error)")
        }
        return false
    }
}

// MARK: - setup Keyboard
extension SignUpFirstViewModel {
    func setupKeyboardHandling(for view: UIView) {
        self.rootView = view
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let rootView = rootView,
              let activeTextField = UIResponder.currentResponder as? UITextField else { return }

        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = rootView.convert(activeTextField.frame, from: activeTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height

        if textFieldBottomY > keyboardTopY {
            let textFieldTopY = convertedTextFieldFrame.origin.y
            let newFrame = textFieldTopY - keyboardTopY / 1.6
            rootView.frame.origin.y = -newFrame
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        rootView?.frame.origin.y = 0
    }
}
