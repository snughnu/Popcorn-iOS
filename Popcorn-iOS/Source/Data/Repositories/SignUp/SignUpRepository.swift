//
//  SignUpRepository.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/4/25.
//

import Foundation

final class SignUpRepository: SignUpRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol

    init(
        networkManager: NetworkManagerProtocol
    ) {
        self.networkManager = networkManager
    }

    func fetchUsernameDuplicationResult(username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endPoint = Endpoint<CheckUsernameResponseDTO>(
            httpMethod: .get,
            path: APIConstant.checkUsernamePath,
            queryItems: [URLQueryItem(name: "username", value: username)]
        )

        // TODO: API변경되면 refactoring
        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let response):
                let resultCode = response.resultCode
                if resultCode == 200 {
                    completion(.success(true))
                } else if resultCode == 400 {
                    completion(.success(false))
                } else {
                    let error = NSError(domain: "SignUpError",
                                        code: resultCode,
                                        userInfo: [NSLocalizedDescriptionKey : "알 수 없는 상태 코드: \(resultCode)"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // TODO: API수정되면 refactoring
    func fetchRequestAuthNumResult(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endPoint = JSONBodyEndpoint<String>(
            httpMethod: .post,
            path: APIConstant.sendVerificationCodePath,
            body: AuthNumRequestDTO(email: email)
        )

        networkManager.request(endpoint: endPoint) { result in
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

    func fetchValidateAuthNumResult(
        email: String,
        authNum: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        let endPoint = JSONBodyEndpoint<ValidateAuthNumResponseDTO>(
            httpMethod: .post,
            path: APIConstant.validateVerificationCodePath,
            body: ValidateAuthNumRequestDTO(email: email, authNum: authNum)
        )

        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let response):
                let resultCode = response.resultCode
                if (200...299).contains(resultCode) {
                    completion(.success(true))
                } else if (400...499).contains(resultCode) {
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

    func fetchSendSignUpDataResult(signupData: SignUpRequestDTO, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endPoint = JSONBodyEndpoint<SignUpResponseDTO>(
            httpMethod: .post,
            path: APIConstant.signUpPath,
            body: signupData
        )

        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let response):
                let resultCode = response.resultCode
                if (200...299).contains(resultCode) {
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
