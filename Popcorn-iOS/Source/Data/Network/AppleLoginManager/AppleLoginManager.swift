//
//  AppleLoginManager.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 3/2/25.
//

import AuthenticationServices

protocol AppleLoginManagerProtocol {
    func loginWithApple(completion: @escaping (Result<IdToken, Error>) -> Void)
}
}
