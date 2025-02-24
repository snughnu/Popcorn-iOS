//
//  SocialLoginRepository.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/28/25.
//

import Foundation
import KakaoSDKUser

// MARK: - Public interface
final class SocialLoginRepository: SocialLoginRepositoryProtocol {
   // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let keychainManager: KeychainManagerProtocol

    // MARK: - Initializer
    init(
        networkManager: NetworkManagerProtocol,
        keychainManager: KeychainManagerProtocol
    ) {
        self.networkManager = networkManager
        self.keychainManager = keychainManager
    }
}

// MARK: - Public interface
extension SocialLoginRepository {
    func isKakaoTalkLoginAvailable() -> Bool {
        return UserApi.isKakaoTalkLoginAvailable()
    }

    func loginWithKakaoTalk(completion: @escaping (Result<IdToken, Error>) -> Void) {
        UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let token = oauthToken,
                  let idTokenString = token.idToken else {
                completion(.failure(NSError(domain: "InvalidToken", code: -1)))
                return
            }

            completion(.success(IdToken(idToken: idTokenString)))
        }
    }

    func loginWithKakaoWeb(completion: @escaping (Result<IdToken, Error>) -> Void) {
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let token = oauthToken,
                  let idTokenString = token.idToken else {
                completion(.failure(NSError(domain: "InvalidToken", code: -1)))
                return
            }

            completion(.success(IdToken(idToken: idTokenString)))
        }
    }

    func fetchNewUserResult(idToken: String, completion: @escaping (Result<SocialLoginResponseDTO, Error>) -> Void) {
        let endPoint = JSONBodyEndpoint<SocialLoginResponseDTO>(
            httpMethod: .post,
            path: APIConstant.isKakaoUserPath,
            body: SocialLoginRequestDTO(idToken: idToken, provider: "KAKAO")
        )
        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let loginResponse):
                completion(.success(loginResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
