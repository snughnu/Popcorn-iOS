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

        let diContainer = DIContainer()

        // MARK: - 토큰 상태에 따른 초기화면 설정
        diContainer.tokenUseCase.handleTokenExpiration { [weak self] isTokenValid in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isTokenValid {
                    let mainSceneViewController = MainSceneViewController()
                    self.window?.rootViewController = UINavigationController(
                        rootViewController: mainSceneViewController
                    )
                } else {
                    let loginViewController = diContainer.makeLoginViewController()
                    self.window?.rootViewController = UINavigationController(rootViewController: loginViewController)
                }
            }
        }

        self.window?.backgroundColor = .systemBackground
        self.window?.makeKeyAndVisible()
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
