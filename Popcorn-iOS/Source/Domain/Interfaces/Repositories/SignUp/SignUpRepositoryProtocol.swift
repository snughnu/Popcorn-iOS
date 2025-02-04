//
//  SignUpRepositoryProtocol.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/4/25.
//

import Foundation

protocol SignUpRepositoryProtocol {
    func checkUsernameAvailability(username: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func requestVerificationCode(email: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func validateVerificationCode(email: String, authNum: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func sendSignUpData(signupData: SignUpRequestDTO, completion: @escaping (Result<Bool, Error>) -> Void)
}
