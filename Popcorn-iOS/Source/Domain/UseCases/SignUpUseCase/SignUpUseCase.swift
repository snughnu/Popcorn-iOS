//
//  SignUpUseCase.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/4/25.
//

import Foundation

protocol SignUpUseCaseProtocol {
    func executeUsernameDuplicationCheck(username: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func executeEmailDuplicationCheck(email: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func executeSendVerificationCode(email: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func executeValidateVerificationCode(
        email: String,
        authNum: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    func executeSendSignUpData(signupData: SignUpRequestDTO, completion: @escaping (Result<Bool, Error>) -> Void)

    func isNameFormatted(_ name: String) -> Bool
    func isIdFormatted(_ id: String) -> Bool
    func isPwFormatted(_ password: String) -> Bool
    func isConfirmPwFormatted(_ password: String, _ confirmPassword: String) -> Bool
    func isEmailFormatted(_ email: String) -> Bool

    func saveSignUpData(name: String, id: String, password: String, email: String) -> Bool
}

class SignUpUseCase: SignUpUseCaseProtocol {
    private let signUpRepository: SignUpRepositoryProtocol

    init(
        signUpRepository: SignUpRepositoryProtocol
    ) {
        self.signUpRepository = signUpRepository
    }
}

// MARK: - Public interface
extension SignUpUseCase {
    func executeUsernameDuplicationCheck(username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        signUpRepository.fetchUsernameDuplicationResult(username: username) { result in
            switch result {
            case .success(let result):
                if result {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func executeEmailDuplicationCheck(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        signUpRepository.fetchEmailDuplicationResult(email: email) { result in
            switch result {
            case .success(let result):
                if result {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func executeSendVerificationCode(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        signUpRepository.fetchRequestAuthNumResult(email: email) { result in
            switch result {
            case .success(let result):
                if result {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func executeValidateVerificationCode(
        email: String,
        authNum: String,
        completion: @escaping (Result<Bool, any Error>) -> Void
    ) {
        signUpRepository.fetchValidateAuthNumResult(email: email, authNum: authNum) { result in
            switch result {
            case .success(let result):
                if result {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func executeSendSignUpData(signupData: SignUpRequestDTO, completion: @escaping (Result<Bool, any Error>) -> Void) {
        signUpRepository.fetchSendSignUpDataResult(signupData: signupData) { result in
            switch result {
            case .success(let result):
                if result {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func saveSignUpData(name: String, id: String, password: String, email: String) -> Bool {
        let data = SignUpRequestDTO(
            firstSignupDto: FirstSignupDto(name: name, username: id, password: password, email: email),
            secondSignupDto: nil
        )
        return signUpRepository.saveSignUpData(signUpData: data)
    }
}

// MARK: - 정규식
extension SignUpUseCase {
    func isNameFormatted(_ name: String) -> Bool {
        let nameRegex = "^[가-힣a-zA-Z]{2,10}$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: name)
    }

    func isIdFormatted(_ id: String) -> Bool {
        let idRegex = "^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]{6,12}$"
        let idTest = NSPredicate(format: "SELF MATCHES %@", idRegex)
        return idTest.evaluate(with: id)
    }

    func isPwFormatted(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*?&#])[A-Za-z\\d@$!%*?&#]{8,16}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    func isConfirmPwFormatted(_ password: String, _ confirmPassword: String) -> Bool {
        let pw = password
        let confirmPw = confirmPassword
        return (pw == confirmPw)
    }

    func isEmailFormatted(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}
