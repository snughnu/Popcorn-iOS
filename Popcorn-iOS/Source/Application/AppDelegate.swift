//
//  AppDelegate.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/10/24.
//

import KakaoSDKCommon
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        KakaoSDK.initSDK(appKey: "e8f4e07ad12752bb2e95ff40160ad6b0")
        registerDependencies()
        return true
    }

    // MARK: - Register Dependencies
    private func registerDependencies() {
        let diContainer = DIContainer.shared

        // MARK: - NetworkManager, KeychainManager
        diContainer.register(
            NetworkManagerProtocol.self,
            instance: NetworkManager()
        )
        diContainer.register(
            KeychainManagerProtocol.self,
            instance: KeychainManager()
        )

        // MARK: - Repositories
        diContainer.register(
            TokenRepositoryProtocol.self,
            instance: TokenRepository(
                networkManager: diContainer.resolve(NetworkManagerProtocol.self),
                keychainManager: diContainer.resolve(KeychainManagerProtocol.self)
            )
        )
        diContainer.register(
            LoginRepositoryProtocol.self,
            instance: LoginRepository(
                networkManager: diContainer.resolve(NetworkManagerProtocol.self)
            )
        )
        diContainer.register(
            SocialLoginRepositoryProtocol.self,
            instance: SocialLoginRepository(
                networkManager: diContainer.resolve(NetworkManagerProtocol.self),
                keychainManager: diContainer.resolve(KeychainManagerProtocol.self)
            )
        )
        diContainer.register(
            SignUpRepositoryProtocol.self,
            instance: SignUpRepository(
                networkManager: diContainer.resolve(NetworkManagerProtocol.self),
                keychainManager: diContainer.resolve(KeychainManagerProtocol.self)
            )
        )

        // MARK: - UseCases
        diContainer.register(
            TokenUseCaseProtocol.self,
            instance: TokenUseCase(
                tokenRepository: diContainer.resolve(TokenRepositoryProtocol.self)
            )
        )
        diContainer.register(
            LoginUseCaseProtocol.self,
            instance: LoginUseCase(
                loginRepository: diContainer.resolve(LoginRepositoryProtocol.self),
                tokenRepository: diContainer.resolve(TokenRepositoryProtocol.self)
            )
        )
        diContainer.register(
            SocialLoginUseCaseProtocol.self,
            instance: SocialLoginUseCase(
                socialLoginRepository: diContainer.resolve(SocialLoginRepositoryProtocol.self),
                tokenRepository: diContainer.resolve(TokenRepositoryProtocol.self)
            )
        )
        diContainer.register(
            SignUpUseCaseProtocol.self,
            instance: SignUpUseCase(
                signUpRepository: diContainer.resolve(SignUpRepositoryProtocol.self)
            )
        )

        // MARK: - ViewModels
        diContainer.register(
            LoginViewModelProtocol.self,
            instance: LoginViewModel(
                loginUseCase: diContainer.resolve(LoginUseCaseProtocol.self)
            )
        )
        diContainer.register(
            SocialLoginViewModelProtocol.self,
            instance: SocialLoginViewModel(
                socialLoginUseCase: diContainer.resolve(SocialLoginUseCaseProtocol.self)
            )
        )
        diContainer.register(
            SignUpFirstViewModelProtocol.self,
            instance: SignUpFirstViewModel(
                signUpUseCase: diContainer.resolve(SignUpUseCaseProtocol.self)
            )
        )
        diContainer.register(
            SignUpSecondViewModelProtocol.self,
            instance: SignUpSecondViewModel(
                signUpUseCase: diContainer.resolve(SignUpUseCaseProtocol.self)
            )
        )
    }

    // MARK: UISceneSession Lifecycle
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
