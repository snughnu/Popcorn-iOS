//
//  LoginManager.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/12/25.
//

import Foundation

final class LoginManager {
    static let shared = LoginManager()
    private init() {}

    func login(username: String, password: String, completion: @escaping (Result<Token, Error>) -> Void) {
        let url = URL(string: "https://popcorm.store/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: String] = [
            "username": username,
            "password": password
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("로그인 요청 실패: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                print("로그인 응답 없음 또는 잘못된 응답")
                completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let loginResponse = try decoder.decode(LoginResponse.self, from: data)

                if (200...299).contains(httpResponse.statusCode) {
                    completion(.success(loginResponse.data))
                } else {
                    let errorMessage = "로그인 실패. 상태 코드: \(httpResponse.statusCode)"
                    print(errorMessage)
                    completion(.failure(NSError(domain: "LoginFailed",
                                                code: httpResponse.statusCode,
                                                userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
            } catch {
                print("로그인 데이터 처리 실패: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
