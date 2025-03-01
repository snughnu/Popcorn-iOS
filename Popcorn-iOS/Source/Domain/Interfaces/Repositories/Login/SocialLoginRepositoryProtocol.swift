//
//  SocialLoginRepository.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/28/25.
//

import Foundation

protocol SocialLoginRepositoryProtocol {
    // MARK: - Kakao
    func isKakaoTalkLoginAvailable() -> Bool
    func loginWithKakaoTalk(completion: @escaping (Result<IdToken, Error>) -> Void)
    func loginWithKakaoWeb(completion: @escaping (Result<IdToken, Error>) -> Void)
    func fetchNewKakaoUserResult(idToken: String, completion: @escaping (Result<SocialLoginResponseDTO, Error>) -> Void)

    // MARK: - Apple
    func loginWithApple(completion: @escaping (Result<IdToken, Error>) -> Void)
    func fetchNewAppleUserResult(idToken: String, completion: @escaping (Result<SocialLoginResponseDTO, Error>) -> Void)
}
