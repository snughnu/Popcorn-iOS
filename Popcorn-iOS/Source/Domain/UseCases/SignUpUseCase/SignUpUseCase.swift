//
//  SignUpUseCase.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/4/25.
//

import Foundation

protocol SignUpUseCaseProtocol {
    func executeUsernameDuplicationCheck(username: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func executeSendVerificationCode(email: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func executeValidateVerificationCode(
        email: String,
        authNum: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    func executeSendSignUpData(signupData: SignUpRequestDTO, completion: @escaping (Result<Bool, Error>) -> Void)
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
            case .success(let resultCode):
                if resultCode == 200 {
                    completion(.success(true))
                } else if resultCode == 400 {
                    completion(.success(false))
                } else {
                    let error = NSError(domain: "SignUpError",
                                        code: resultCode,
                                        userInfo: [NSLocalizedDescriptionKey: "알 수 없는 상태 코드: \(resultCode)"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func executeSendVerificationCode(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        signUpRepository.fetchRequestVerificationCodeResult(email: email) { result in
            switch result {
            case .success(let response):
                if response.contains("발송") || response.contains("성공") {
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
        signUpRepository.fetchValidateVerificationCodeResult(email: email, authNum: authNum) { result in
            switch result {
            case .success(let resultCode):
                if resultCode == 200 {
                    completion(.success(true))
                } else if resultCode == 400 {
                    completion(.success(false))
                } else {
                    let error = NSError(domain: "SignUpError",
                                        code: resultCode,
                                        userInfo: [NSLocalizedDescriptionKey: "알 수 없는 상태 코드: \(resultCode)"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func executeSendSignUpData(signupData: SignUpRequestDTO, completion: @escaping (Result<Bool, any Error>) -> Void) {
        signUpRepository.fetchSendSignUpDataResult(signupData: signupData) { result in
            switch result {
            case .success(let resultCode):
                if resultCode == 200 {
                    completion(.success(true))
                } else if resultCode == 102 {
                    completion(.success(false))
                } else {
                    let error = NSError(domain: "SignUpError",
                                        code: resultCode,
                                        userInfo: [NSLocalizedDescriptionKey: "알 수 없는 상태 코드: \(resultCode)"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
