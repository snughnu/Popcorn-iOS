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
    func fetchUserInfo(completion: @escaping (Result<String, Error>) -> Void)
    func sendTokenToServer(completion: @escaping () -> Void)
}
