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

    func checkUsernameAvailability(username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endPoint = Endpoint<CheckUsernameResponseDTO>(
            httpMethod: .get,
            path: APIConstant.checkUsernamePath,
            queryItems: [URLQueryItem(name: "username", value: username)]
        )

        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let checkUsernameResponse):
                let isAvailable = checkUsernameResponse.resultCode == 200
                completion(.success(isAvailable))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func requestVerificationCode(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endPoint = JSONBodyEndpoint<String>(
            httpMethod: .post,
            path: APIConstant.sendVerificationCodePath,
            body: VerificationCodeRequestDTO(email: email)
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

    func validateVerificationCode(email: String, authNum: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endPoint = JSONBodyEndpoint<ValidateVerificationCodeResponseDTO>(
            httpMethod: .post,
            path: APIConstant.validateVerificationCodePath,
            body: ValidateVerificationCodeRequestDTO(email: email, authNum: authNum)
        )

        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let response):
                let isSuccess = response.resultCode == 200
                completion(.success(isSuccess))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func sendSignUpData(signupData: SignUpRequestDTO, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endPoint = JSONBodyEndpoint<SignUpResponseDTO>(
            httpMethod: .post,
            path: APIConstant.signUpPath,
            body: signupData
        )

        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let response):
                if response.resultCode == 200 {
                    completion(.success(true))
                } else if response.resultCode == 102 {
                    let error = NSError(
                        domain: "SignupError",
                        code: 102,
                        userInfo: [NSLocalizedDescriptionKey: "이미 존재하는 이메일"]
                    )
                    completion(.failure(error))
                } else if let serverError = ServerError(rawValue: response.resultCode) {
                    let error = NSError(
                        domain: "ServerError",
                        code: serverError.rawValue,
                        userInfo: [NSLocalizedDescriptionKey: "서버 오류: \(serverError)"]
                    )
                    completion(.failure(error))
                } else {
                    let error = NSError(
                        domain: "UnknownError",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "알 수 없는 오류"]
                    )
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
