//
//  SocialLoginRepository.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/28/25.
//

import Foundation

protocol SocialLoginRepositoryProtocol {
    func isKakaoTalkLoginAvailable() -> Bool
    func loginWithKakaoTalk(completion: @escaping (Result<IdToken, Error>) -> Void)
    func loginWithKakaoWeb(completion: @escaping (Result<IdToken, Error>) -> Void)
    func fetchNewUserResult(idToken: String, completion: @escaping (Result<SocialLoginResponseDTO, Error>) -> Void)
}
