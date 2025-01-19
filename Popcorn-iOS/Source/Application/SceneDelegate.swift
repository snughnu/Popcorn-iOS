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

        let tokenExpireResolver = TokenExpireResolver()

        tokenExpireResolver.handleTokenExpiration { [weak self] isTokenValid in
            DispatchQueue.main.async {
                if isTokenValid {
                    self?.showMainScene()
                } else {
                    self?.showLoginScene()
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

    private func showLoginScene() {
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        self.window?.rootViewController = navigationController
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
