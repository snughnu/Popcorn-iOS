//
//  SignUpRepository.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/4/25.
//

import Foundation

final class SignUpRepository: SignUpRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol
    private let keychainManager: KeychainManagerProtocol

    init(
        networkManager: NetworkManagerProtocol,
        keychainManager: KeychainManagerProtocol
    ) {
        self.networkManager = networkManager
        self.keychainManager = keychainManager
    }
}

// MARK: - Public method - FirstScene signUp method
extension SignUpRepository {
    func fetchUsernameDuplicationResult(username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endPoint = Endpoint<CheckUsernameResponseDTO>(
            httpMethod: .get,
            path: APIConstant.checkUsernamePath,
            queryItems: [URLQueryItem(name: "username", value: username)]
        )

        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let response):
                let isDuplicated = response.status.contains("fail")
                if !isDuplicated {
                    completion(.success(true))
                } else if isDuplicated {
                    completion(.success(false))
                } else {
                    let error = NSError(domain: "SignUpError",
                                        code: response.resultCode,
                                        userInfo: [NSLocalizedDescriptionKey: "알 수 없는 상태 코드: \(response.resultCode)"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchEmailDuplicationResult(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endPoint = Endpoint<CheckDuplicationEmailResponseDTO>(
            httpMethod: .get,
            path: APIConstant.checkDuplicationEmailPath,
            queryItems: [URLQueryItem(name: "email", value: email)]
        )

        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let response):
                let isDuplicated = response.status.contains("fail")
                if !isDuplicated {
                    completion(.success(true))
                } else if isDuplicated {
                    completion(.success(false))
                } else {
                    let error = NSError(domain: "SignUpError",
                                        code: response.resultCode,
                                        userInfo: [NSLocalizedDescriptionKey: "알 수 없는 상태 코드: \(response.resultCode)"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchRequestAuthNumResult(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endPoint = JSONBodyEndpoint<AuthNumResultResponseDTO>(
            httpMethod: .post,
            path: APIConstant.sendAuthNumPath,
            body: AuthNumRequestDTO(email: email)
        )

        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let response):
                if response.resultCode == 200 {
                    completion(.success(true))
                } else {
                    let error = NSError(domain: "SignUpError",
                                        code: response.resultCode,
                                        userInfo: [NSLocalizedDescriptionKey: "알 수 없는 상태 코드: \(response.resultCode)"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchValidateAuthNumResult(
        email: String,
        authNum: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        let endPoint = JSONBodyEndpoint<ValidateAuthNumResponseDTO>(
            httpMethod: .post,
            path: APIConstant.validateAuthNumPath,
            body: ValidateAuthNumRequestDTO(email: email, authNum: authNum)
        )

        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let response):
                let resultCode = response.resultCode
                if (200...299).contains(resultCode) {
                    completion(.success(true))
                } else if (400...499).contains(resultCode) {
                    completion(.success(false))
                } else {
                    let error = NSError(domain: "SignUpError",
                                        code: resultCode,
                                        userInfo: [NSLocalizedDescriptionKey: "알 수 없는 상태 코드: \(resultCode)"])
                    completion(.failure(error))
                }
            case .failure(let error):
                if case .serverError(let serverError) = error, (400...499).contains(serverError.rawValue) {
                    completion(.success(false))
                    return
                }
                completion(.failure(error))
            }
        }
    }

    func saveSignUpData(signUpData: SignUpRequestDTO) -> Bool {
        do {
            let jsonData = try JSONEncoder().encode(signUpData)
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "signupData"
            ]
            let attributes: [String: Any] = [
                kSecValueData as String: jsonData
            ]

            let status = keychainManager.updateItem(with: query, as: attributes)

            if status == errSecItemNotFound {
                let addQuery = query.merging(attributes) { _, new in new }
                let addStatus = keychainManager.addItem(with: addQuery)
                return addStatus == errSecSuccess
            } else if status == errSecSuccess {
                return true
            }
        } catch {
            print("데이터 인코딩 실패: \(error)")
        }
        return false
    }
}

// MARK: - Public method - SecondScene signUp method
extension SignUpRepository {
    func fetchSignUpDataFromKeychain() -> SignUpRequestDTO? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "signupData",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        guard let data = keychainManager.fetchItem(with: query) else {
            print("키체인에서 데이터를 불러올 수 없습니다.")
            return nil
        }

        do {
            let signupData = try JSONDecoder().decode(SignUpRequestDTO.self, from: data)
            print("키체인 Load SignUp Data 성공: \(signupData)")
            return signupData
        } catch {
            print("키체인 Load SignUp Data 디코딩 실패: \(error)")
            return nil
        }
    }

    func fetchSignUpResult(signupData: SignUpRequestDTO, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endPoint = JSONBodyEndpoint<SignUpResponseDTO>(
            httpMethod: .post,
            path: APIConstant.signUpPath,
            body: signupData
        )

        networkManager.request(endpoint: endPoint) { result in
            switch result {
            case .success(let response):
                let resultCode = response.resultCode
                if (200...299).contains(resultCode) {
                    completion(.success(true))
                } else if resultCode == 102 {
                    completion(.success(false))
                } else {
                    let error = NSError(domain: "SignUpError",
                                        code: resultCode,
                                        userInfo: [NSLocalizedDescriptionKey: "알 수 없는 상태 코드: \(resultCode)"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchKakaoSignUpResult(
        signupData: SocialSignUpRequestDTO,
        completion: @escaping (Token) -> Void
    ) {
        let endPoint = JSONBodyEndpoint<SocialSignUpResponseDTO>(
            httpMethod: .post,
            path: APIConstant.kakaoSignUpPath,
            body: signupData
        )

        networkManager.request(endpoint: endPoint) { result in
            if case .success(let response) = result {
                completion(response.toToken())
            }
        }
    }

    func fetchIdToken() -> String? {
        return keychainManager.fetchIdToken()
    }

    func fetchDeleteIdTokenResult() -> Bool {
        return keychainManager.deleteIdToken() == errSecSuccess
    }
}
