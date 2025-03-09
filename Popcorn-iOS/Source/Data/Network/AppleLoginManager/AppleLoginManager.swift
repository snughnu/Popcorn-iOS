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

final class AppleLoginManager: NSObject, AppleLoginManagerProtocol {
    private var completion: ((Result<IdToken, Error>) -> Void)?

    // MARK: - Public interface
    func loginWithApple(completion: @escaping (Result<IdToken, Error>) -> Void) {
        self.completion = completion

        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AppleLoginManager: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let idTokenData = appleIDCredential.identityToken,
              let idTokenString = String(data: idTokenData, encoding: .utf8) else {
            completion?(.failure(
                NSError(domain: "AppleLogin", code: -1, userInfo: [NSLocalizedDescriptionKey: "ID 토큰이 없습니다."]))
            )
            return
        }
        completion?(.success(IdToken(idToken: idTokenString)))
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion?(.failure(error))
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension AppleLoginManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }
}
