//
//  SignUpRepositoryProtocol.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/4/25.
//

import Foundation

protocol SignUpRepositoryProtocol {
    func fetchUsernameDuplicationResult(username: String, completion: @escaping (Result<Int, Error>) -> Void)
    func fetchRequestVerificationCodeResult(email: String, completion: @escaping (Result<String, Error>) -> Void)
    func fetchValidateVerificationCodeResult(
        email: String,
        authNum: String,
        completion: @escaping (Result<Int, Error>) -> Void
    )
    func fetchSendSignUpDataResult(signupData: SignUpRequestDTO, completion: @escaping (Result<Int, Error>) -> Void)
}
