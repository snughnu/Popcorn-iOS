//
//  SignUpFirstViewModel.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/4/25.
//

import Foundation

protocol SignUpFirstViewModelProtocol {
    var nameMessageHandler: ((String, Bool) -> Void)? { get set }
    var idMessageHandler: ((String, Bool) -> Void)? { get set }
    var pwMessageHandler: ((String, Bool) -> Void)? { get set }
    var confirmPwMessageHandler: ((String, Bool) -> Void)? { get set }
    var emailMessageHandler: ((String, Bool) -> Void)? { get set }
    var authNumMessageHandler: ((String, Bool) -> Void)? { get set }
    var allFieldsValidHandler: ((Bool) -> Void)? { get set }
    var navigateToSignUpSecondHandler: (() -> Void)? { get set }

    func updateName(_ name: String)
    func updateId(_ id: String)
    func updatePw(_ pw: String)
    func updateConfirmPw(_ pw: String, _ confirmPw: String)
    func updateEmail(_ email: String)
    func updateAuthNum(_ authNum: String)
    func checkUsernameAvailability(username: String)
    func checkEmailAndRequestAuthNum(email: String)
    func requestAuthNum(email: String)
    func validateAuthNum(email: String, authNum: String)
}

final class SignUpFirstViewModel: SignUpFirstViewModelProtocol {
    // MARK: - Properties
    private let signUpUseCase: SignUpUseCaseProtocol

    // MARK: - 입력값 검사
    private var name: String = "" {
        didSet {
            isNameValid = signUpUseCase.isNameFormatted(name)
            let message = isNameValid ? " " : "*이름을 올바르게 입력해주세요."
            nameMessageHandler?(message, isNameValid)
        }
    }

    private var id: String = "" {
        didSet {
            isIdValid = signUpUseCase.isIdFormatted(id)
            let message = isIdValid ? " " : "*6~12자의 영문과 숫자의 조합으로 입력해주세요."
            idMessageHandler?(message, isIdValid)
        }
    }

    private var pw: String = "" {
        didSet {
            isPwValid = signUpUseCase.isPwFormatted(pw)
            let message = isPwValid ? "*사용 가능한 비밀번호 입니다." : "*8~16자, 영문, 숫자, 특수문자를 조합해주세요."
            pwMessageHandler?(message, isPwValid)
        }
    }

    private var confirmPw: String = "" {
        didSet {
            isConfirmPwValid = signUpUseCase.isConfirmPwFormatted(pw, confirmPw)
            let message = isConfirmPwValid ? "*비밀번호가 일치합니다." : "*비밀번호가 일치하지 않습니다."
            confirmPwMessageHandler?(message, isConfirmPwValid)
        }
    }

    private var email: String = "" {
        didSet {
            isEmailValid = signUpUseCase.isEmailFormatted(email)
            let message = isEmailValid ? " " : "*이메일을 올바르게 입력해주세요."
            emailMessageHandler?(message, isEmailValid)
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
    var nameMessageHandler: ((String, Bool) -> Void)?
    var idMessageHandler: ((String, Bool) -> Void)?
    var pwMessageHandler: ((String, Bool) -> Void)?
    var confirmPwMessageHandler: ((String, Bool) -> Void)?
    var emailMessageHandler: ((String, Bool) -> Void)?
    var authNumMessageHandler: ((String, Bool) -> Void)?
    var allFieldsValidHandler: ((Bool) -> Void)?
    var navigateToSignUpSecondHandler: (() -> Void)?

    // MARK: - Initializer
    init(
        signUpUseCase: SignUpUseCaseProtocol
    ) {
        self.signUpUseCase = signUpUseCase
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
        isIdFormattedValid = signUpUseCase.isIdFormatted(id)
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
            idMessageHandler?("*6~12자의 영문과 숫자의 조합으로 입력해주세요.", false)
            return
        }
        signUpUseCase.executeUsernameDuplicationCheck(username: username) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isAvailable):
                    self?.isIdValid = isAvailable
                    let message = isAvailable ? "*사용 가능한 아이디입니다." : "*중복된 아이디입니다."
                    self?.idMessageHandler?(message, isAvailable)
                case .failure:
                    self?.idMessageHandler?("*아이디 중복 확인 실패.", false)
                }
            }
        }
    }

    func checkEmailAndRequestAuthNum(email: String) {
        guard isEmailValid else {
            emailMessageHandler?("*이메일을 올바르게 입력해주세요.", false)
            return
        }
        signUpUseCase.executeEmailDuplicationCheck(email: email) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isAvailable):
                    if isAvailable {
                        self?.requestAuthNum(email: email)
                    } else {
                        self?.emailMessageHandler?("*중복된 이메일입니다.", false)
                    }
                case .failure:
                    self?.emailMessageHandler?("*네트워크 오류", false)
                }
            }
        }
    }

    func requestAuthNum(email: String) {
        guard isEmailValid else {
            emailMessageHandler?("*이메일을 올바르게 입력해주세요.", false)
            return
        }
        signUpUseCase.executeSendVerificationCode(email: email) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isSuccess):
                    let message = isSuccess ? "*인증번호가 발송되었습니다." : "*인증번호 전송 실패."
                    self?.emailMessageHandler?(message, isSuccess)
                case .failure:
                    self?.emailMessageHandler?("*네트워크 오류.", false)
                }
            }
        }
    }

    func validateAuthNum(email: String, authNum: String) {
        guard isAllValid else {
            authNumMessageHandler?("*모든 정보를 올바르게 입력해주세요.", false)
            return
        }
        signUpUseCase.executeValidateVerificationCode(email: email, authNum: authNum) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let isSuccess):
                    if isSuccess {
                        let isSaved = self.signUpUseCase.saveSignUpData(
                            name: self.name,
                            id: self.id,
                            password: self.pw,
                            email: self.email
                        )
                        if isSaved {
                            self.navigateToSignUpSecondHandler?()
                        } else {
                            self.authNumMessageHandler?("*데이터 저장에 실패했습니다.", false)
                        }
                    } else {
                        self.authNumMessageHandler?("*인증번호가 올바르지 않습니다.", false)
                    }
                case .failure:
                    self.authNumMessageHandler?("*네트워크 오류가 발생했습니다.", false)
                }
            }
        }
    }
}
