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

    func login(username: String, password: String, completion: @escaping (Result<LoginData, Error>) -> Void) {
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
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let data = data else {
                completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                if loginResponse.status == "success" {
                    completion(.success(loginResponse.data))
                } else {
                    completion(.failure(NSError(domain: "LoginFailed", code: -1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
