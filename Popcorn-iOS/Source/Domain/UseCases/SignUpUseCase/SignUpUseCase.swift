//
//  SignUpUseCase.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/4/25.
//

import Foundation

protocol SignUpUseCaseProtocol {
    // MARK: - FirstScene signUp method
    func executeUsernameDuplicationCheck(username: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func executeEmailDuplicationCheck(email: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func executeSendAuthNum(email: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func executeValidateAuthNum(
        email: String,
        authNum: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    func saveSignUpData(name: String, id: String, password: String, email: String) -> Bool
    func isNameFormatted(_ name: String) -> Bool
    func isIdFormatted(_ id: String) -> Bool
    func isPwFormatted(_ password: String) -> Bool
    func isConfirmPwFormatted(_ password: String, _ confirmPassword: String) -> Bool
    func isEmailFormatted(_ email: String) -> Bool

    // MARK: - SecondScene signUp method
    func executeSignUp(
        nickName: String,
        profileId: Int,
        interests: [String],
        completion: @escaping (Result<Bool, Error>, String) -> Void
    )
}

final class SignUpUseCase: SignUpUseCaseProtocol {
    // MARK: - Properties
    private let signUpRepository: SignUpRepositoryProtocol
    private let tokenRepository: TokenRepositoryProtocol

    // MARK: - Initializer
    init(
        signUpRepository: SignUpRepositoryProtocol,
        tokenRepository: TokenRepositoryProtocol
    ) {
        self.signUpRepository = signUpRepository
        self.tokenRepository = tokenRepository
    }

    // MARK: - Private func
    private func convertInterestToEnglish(_ interest: String) -> String {
        return InterestCategory(rawValue: interest)?.serverValue ?? interest
    }
}

// MARK: - Public interface - FirstScene signUp method
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

    func executeSendAuthNum(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
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

    func executeValidateAuthNum(
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

    func saveSignUpData(name: String, id: String, password: String, email: String) -> Bool {
        let data = SignUpRequestDTO(
            firstSignupDTO: FirstSignupDTO(name: name, username: id, password: password, email: email),
            secondSignupDTO: nil
        )
        return signUpRepository.saveSignUpData(signUpData: data)
    }
}

// MARK: - FirstScene signUp 정규식 method
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

// MARK: - SecondScene signUp method
extension SignUpUseCase {
    func executeSignUp(
        nickName: String,
        profileId: Int,
        interests: [String],
        completion: @escaping (Result<Bool, Error>, String) -> Void
    ) {
        let convertedInterests = interests.map { convertInterestToEnglish($0) }

        if let idToken = signUpRepository.fetchIdToken(),
           let loginType = signUpRepository.fetchLoginType() {

            let socialSignUpData = SocialSignUpRequestDTO(
                idToken: idToken,
                secondSignupDTO: SecondSignupDTO(
                    nickname: nickName,
                    profileId: profileId,
                    interests: convertedInterests
                )
            )

            if loginType == "kakao" {
                signUpRepository.fetchKakaoSignUpResult(signupData: socialSignUpData) { [weak self] token in
                    guard let self = self else { return }
                    self.tokenRepository.saveToken(with: token, loginType: "kakao")
                    _ = self.signUpRepository.fetchDeleteIdTokenResult()
                    completion(.success(true), "로그인 화면으로 이동합니다.")
                }
            } else if loginType == "apple" {
                signUpRepository.fetchAppleSignUpResult(signupData: socialSignUpData) { [weak self] token in
                    guard let self = self else { return }
                    self.tokenRepository.saveToken(with: token, loginType: "apple")
                    _ = self.signUpRepository.fetchDeleteIdTokenResult()
                    completion(.success(true), "로그인 화면으로 이동합니다.")
                }
            }

        } else {
            guard let firstSignUpData = signUpRepository.fetchSignUpDataFromKeychain() else {
                completion(.failure(NSError(domain: "SignUpError",
                                            code: -1,
                                            userInfo: nil)), "회원가입 첫 번째 단계 데이터를 찾을 수 없습니다.")
                return
            }

            let signUpData = SignUpRequestDTO(
                firstSignupDTO: firstSignUpData.firstSignupDTO,
                secondSignupDTO: SecondSignupDTO(
                    nickname: nickName,
                    profileId: profileId,
                    interests: convertedInterests
                )
            )

            signUpRepository.fetchSignUpResult(signupData: signUpData) { result in
                switch result {
                case .success(let success):
                    completion(.success(success), success ? "로그인 화면으로 이동합니다." : "이미 가입된 이메일입니다.")
                case .failure(let error):
                    completion(.failure(error), "\(error.localizedDescription)")
                }
            }
        }
    }
}
