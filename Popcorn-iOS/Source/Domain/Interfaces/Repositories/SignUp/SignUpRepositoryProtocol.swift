//
//  SignUpRepositoryProtocol.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/4/25.
//

import Foundation

protocol SignUpRepositoryProtocol {
    func fetchUsernameDuplicationResult(username: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func fetchEmailDuplicationResult(email: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func fetchRequestAuthNumResult(email: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func fetchValidateAuthNumResult(
        email: String,
        authNum: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    func fetchSendSignUpDataResult(signupData: SignUpRequestDTO, completion: @escaping (Result<Bool, Error>) -> Void)
    func saveSignUpData(signUpData: SignUpRequestDTO) -> Bool
}
