//
//  LoginRepository.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/28/25.
//

import Foundation

final class LoginRepository: LoginRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol

    init(
        networkManager: NetworkManagerProtocol
    ) {
        self.networkManager = networkManager
    }

    func login(username: String, password: String, completion: @escaping (Result<Token, Error>) -> Void) {
        let endPoint = JSONBodyEndpoint<LoginResponseDTO>(
            httpMethod: .post,
            path: APIConstant.loginPath,
            body: LoginRequestDTO(username: username, password: password)
        )

        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let loginResponse):
                completion(.success(loginResponse.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
