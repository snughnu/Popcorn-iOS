//
//  LoginUseCase.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/28/25.
//

import Foundation

protocol LoginUseCaseProtocol {
    func login(username: String, password: String, completion: @escaping (Result<Token, Error>) -> Void)
}

final class LoginUseCase: LoginUseCaseProtocol {
    private let loginRepository: LoginRepositoryProtocol
    private let tokenRepository: TokenRepositoryProtocol

    init(
        loginRepository: LoginRepositoryProtocol,
        tokenRepository: TokenRepositoryProtocol
    ) {
        self.loginRepository = loginRepository
        self.tokenRepository = tokenRepository
    }

    func login(username: String, password: String, completion: @escaping (Result<Token, Error>) -> Void) {
        loginRepository.login(username: username, password: password) { [weak self] result in
            switch result {
            case .success(let token):
                self?.tokenRepository.saveToken(with: token, loginType: nil)
                completion(.success(token))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
