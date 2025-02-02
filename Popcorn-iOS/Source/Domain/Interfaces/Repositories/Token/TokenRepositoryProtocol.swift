//
//  TokenRepositoryProtocol.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/13/25.
//

import Foundation

protocol TokenRepositoryProtocol {
    func saveToken(with token: Token, loginType: String?)
    func deleteTokens()

    func fetchAccessToken() -> String?
    func fetchRefreshToken() -> String?
    func fetchLoginType() -> String?
    func fetchAccessTokenExpirationDate() -> Date?
    func fetchRefreshTokenExpirationDate() -> Date?

    func reissueAccessToken(refreshToken: String, completion: @escaping (Result<NewToken, Error>) -> Void)
    func reissueKakaoAccessToken(refreshToken: String, completion: @escaping (Result<Token, Error>) -> Void)
}
