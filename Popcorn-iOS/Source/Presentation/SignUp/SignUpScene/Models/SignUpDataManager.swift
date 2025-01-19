//
//  SignUpDataManager.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/19/25.
//

import Foundation

final class SignupDataManager {
    static let shared = SignupDataManager()
    private init() {}

    // MARK: - 인증 번호 전송
    func sendVerificationCode(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = URL(string: "https://popcorm.store/mailsend")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: String] = ["email": email]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("인증번호 전송 요청 실패: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                print("인증번호 전송 응답 없음 또는 잘못된 응답")
                completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                return
            }

            if httpResponse.statusCode != 200 {
                let errorMessage = String(data: data, encoding: .utf8) ?? "알 수 없는 오류"
                print("인증번호 전송 실패. 상태 코드: \(httpResponse.statusCode), 오류 메시지: \(errorMessage)")
                completion(.failure(NSError(domain: "ServerError",
                                            code: httpResponse.statusCode,
                                            userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                return
            }

            completion(.success(true))
        }
        task.resume()
    }

    // MARK: - 이메일 인증 번호 확인
    func verifyAuthCode(email: String, authNum: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = URL(string: "https://popcorm.store/mailauthChk")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: String] = [
            "email": email,
            "authNum": authNum
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("인증번호 확인 요청 실패: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                print("인증번호 확인 응답 없음 또는 잘못된 응답")
                completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                return
            }

            if httpResponse.statusCode != 200 {
                let errorMessage = String(data: data, encoding: .utf8) ?? "알 수 없는 오류"
                print("인증번호 확인 실패. 상태 코드: \(httpResponse.statusCode), 오류 메시지: \(errorMessage)")
                completion(.failure(NSError(domain: "ServerError",
                                            code: httpResponse.statusCode,
                                            userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                return
            }

            completion(.success(true))
        }
        task.resume()
    }

    // MARK: - 가입하기 버튼 동작
    func submitSignupData(signupData: SignUpData, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = URL(string: "https://popcorm.store/auth/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(signupData)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("회원가입 요청 실패: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                print("회원가입 응답 없음 또는 잘못된 응답")
                completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                return
            }

            if httpResponse.statusCode != 200 {
                let errorMessage = String(data: data, encoding: .utf8) ?? "알 수 없는 오류"
                print("회원가입 실패. 상태 코드: \(httpResponse.statusCode), 오류 메시지: \(errorMessage)")
                completion(.failure(NSError(domain: "ServerError",
                                            code: httpResponse.statusCode,
                                            userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                return
            }

            completion(.success(true))
        }
        task.resume()
    }
}
