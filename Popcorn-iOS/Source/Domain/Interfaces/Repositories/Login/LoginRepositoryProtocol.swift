//
//  LoginRepositoryProtocol.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/28/25.
//

protocol LoginRepositoryProtocol {
    func login(username: String, password: String, completion: @escaping (Result<Token, Error>) -> Void)
}
