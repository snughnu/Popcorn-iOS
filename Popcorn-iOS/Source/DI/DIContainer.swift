//
//  DIContainer.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/16/25.
//

import Foundation

final class DIContainer {
    // MARK: - Network, Keychain
    private let networkManager: NetworkManagerProtocol
    private let keychainManager: KeychainManagerProtocol
    
    // MARK: - Token
    private let tokenRepository: TokenRepositoryProtocol
    let tokenUseCase: TokenUseCaseProtocol
    
    // MARK: - Login
    private let loginRepository: LoginRepositoryProtocol
    private let loginUseCase: LoginUseCaseProtocol
    
    // MARK: - Social Login
    private let socialLoginRepository: SocialLoginRepositoryProtocol
    private let socialLoginUseCase: SocialLoginUseCaseProtocol
    
    // MARK: - SignUp
    private let signUpRepository: SignUpRepositoryProtocol
    private let signUpUseCase: SignUpUseCaseProtocol
    
    // MARK: - Initializer
    init() {
        self.networkManager = NetworkManager()
        self.keychainManager = KeychainManager()
        
        self.tokenRepository = TokenRepository(networkManager: networkManager, keychainManager: keychainManager)
        self.loginRepository = LoginRepository(networkManager: networkManager)
        self.socialLoginRepository = SocialLoginRepository(networkManager: networkManager, keychainManager: keychainManager)
        self.signUpRepository = SignUpRepository(networkManager: networkManager, keychainManager: keychainManager)
        
        self.tokenUseCase = TokenUseCase(tokenRepository: tokenRepository)
        self.loginUseCase = LoginUseCase(loginRepository: loginRepository, tokenRepository: tokenRepository)
        self.socialLoginUseCase = SocialLoginUseCase(socialLoginRepository: socialLoginRepository, tokenRepository: tokenRepository)
        self.signUpUseCase = SignUpUseCase(signUpRepository: signUpRepository)
    }
}

// MARK: - ViewModel, ViewController 생성
extension DIContainer {
    // MARK: - Login
    func makeLoginViewModel() -> LoginViewModelProtocol {
        return LoginViewModel(loginUseCase: loginUseCase)
    }

    func makeSocialLoginViewModel() -> SocialLoginViewModelProtocol {
        return SocialLoginViewModel(socialLoginUseCase: socialLoginUseCase)
    }

    func makeLoginViewController() -> LoginViewController {
        return LoginViewController(
            loginViewModel: makeLoginViewModel(),
            socialLoginViewModel: makeSocialLoginViewModel()
        )
    }

    // MARK: - SignUp
    func makeSignUpFirstViewModel() -> SignUpFirstViewModelProtocol {
        return SignUpFirstViewModel(signUpUseCase: signUpUseCase)
    }

    func makeSignUpSecondViewModel() -> SignUpSecondViewModelProtocol {
        return SignUpSecondViewModel(signUpUseCase: signUpUseCase)
    }

    func makeSignUpFirstViewController() -> SignUpFirstViewController {
        return SignUpFirstViewController(signUpFirstViewModel: makeSignUpFirstViewModel())
    }

    func makeSignUpSecondViewController() -> SignUpSecondViewController {
        return SignUpSecondViewController(signUpSecondViewModel: makeSignUpSecondViewModel())
    }
}
