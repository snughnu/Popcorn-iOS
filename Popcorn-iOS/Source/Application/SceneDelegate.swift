//
//  SceneDelegate.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/10/24.
//

import KakaoSDKAuth
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        // MARK: - Dependency injection
        let keyChainManager = KeychainManager()
        let networkManager = NetworkManager()

        let tokenRepository = TokenRepository(
            networkManager: networkManager,
            keychainManager: keyChainManager
        )
        let loginRepository = LoginRepository(networkManager: networkManager)
        let socialLoginRepository = SocialLoginRepository()

        let tokenUseCase = TokenUseCase(tokenRepository: tokenRepository)
        let loginUseCase = LoginUseCase(
            loginRepository: loginRepository,
            tokenRepository: tokenRepository
        )
        let socialLoginUseCase = SocialLoginUseCase(
            socialLoginRepository: socialLoginRepository,
            tokenRepository: tokenRepository
        )

        let loginViewModel = LoginViewModel(loginUseCase: loginUseCase)
        let socialLoginViewModel = SocialLoginViewModel(socialLoginUseCase: socialLoginUseCase)

        // MARK: - 토큰 상태에 따른 초기화면 설정
        tokenUseCase.handleTokenExpiration { [weak self] isTokenValid in
            DispatchQueue.main.async {
                if isTokenValid {
                    self?.showMainScene()
                } else {
                    self?.showLoginScene(
                        loginViewModel: loginViewModel,
                        socialLoginViewModel: socialLoginViewModel
                    )
                }
            }
        }

        self.window?.backgroundColor = .systemBackground
        self.window?.makeKeyAndVisible()
    }

    private func showMainScene() {
        let mainSceneViewController = MainSceneViewController()
        self.window?.rootViewController = UINavigationController(rootViewController: mainSceneViewController)
    }

    private func showLoginScene(
        loginViewModel: LoginViewModel,
        socialLoginViewModel: SocialLoginViewModel
    ) {
        let loginViewController = LoginViewController(
            loginViewModel: loginViewModel,
            socialLoginViewModel: socialLoginViewModel
        )
        self.window?.rootViewController = UINavigationController(rootViewController: loginViewController)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
