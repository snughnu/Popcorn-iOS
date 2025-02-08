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

    func fetchUsernameDuplicationResult(username: String, completion: @escaping (Result<Int, Error>) -> Void) {
        let endPoint = Endpoint<CheckUsernameResponseDTO>(
            httpMethod: .get,
            path: APIConstant.checkUsernamePath,
            queryItems: [URLQueryItem(name: "username", value: username)]
        )

        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let checkUsernameResponse):
                let resultCode = checkUsernameResponse.resultCode
                completion(.success(resultCode))
            case .failure(let error):
                if case NetworkError.serverError(.badRequest) = error {
                    completion(.success(400))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }

    func fetchRequestVerificationCodeResult(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endPoint = JSONBodyEndpoint<String>(
            httpMethod: .post,
            path: APIConstant.sendVerificationCodePath,
            body: AuthNumRequestDTO(email: email)
        )

        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchValidateVerificationCodeResult(email: String, authNum: String, completion: @escaping (Result<Int, Error>) -> Void) {
        let endPoint = JSONBodyEndpoint<ValidateAuthNumResponseDTO>(
            httpMethod: .post,
            path: APIConstant.validateVerificationCodePath,
            body: ValidateAuthNumRequestDTO(email: email, authNum: authNum)
        )

        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let response):
                let resultCode = response.resultCode
                completion(.success(resultCode))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchSendSignUpDataResult(signupData: SignUpRequestDTO, completion: @escaping (Result<Int, Error>) -> Void) {
        let endPoint = JSONBodyEndpoint<SignUpResponseDTO>(
            httpMethod: .post,
            path: APIConstant.signUpPath,
            body: signupData
        )

        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let response):
                let resultCode = response.resultCode
                completion(.success(resultCode))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
