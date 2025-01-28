//
//  LoginManager.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/12/25.
//

import Foundation

final class LoginManager {
    private let networkManager: NetworkManagerProtocol
    private let tokenRepository: TokenRepository

    init(
        networkManager: NetworkManagerProtocol,
        tokenRepository: TokenRepository
    ) {
        self.networkManager = networkManager
        self.tokenRepository = tokenRepository
    }
}

// MARK: - Public Interface
extension LoginManager {
    func login(username: String, password: String, completion: @escaping (Result<Token, Error>) -> Void) {
        let endPoint = JSONBodyEndpoint<LoginResponse>(
            httpMethod: .post,
            path: APIConstant.loginPath,
            body: LoginRequestDTO(username: username, password: password)
        )

        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let loginResponse):
                let token = loginResponse.data
                self.tokenRepository.saveToken(with: token)
                completion(.success(token))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
