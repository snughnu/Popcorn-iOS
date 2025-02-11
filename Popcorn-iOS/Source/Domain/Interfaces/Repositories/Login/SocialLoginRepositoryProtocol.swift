//
//  SocialLoginRepository.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/28/25.
//

import Foundation

protocol SocialLoginRepositoryProtocol {
    func loginWithKaKaoTalk(completion: @escaping (Result<Token, Error>) -> Void)
    func loginWithKakaoWeb(completion: @escaping (Result<Token, Error>) -> Void)
    func fetchIdToken(completion: @escaping (Result<IdToken, Error>) -> Void)
    func fetchNewUserResult(idToken: String, completion: @escaping (Result<Bool, Error>) -> Void)
}
