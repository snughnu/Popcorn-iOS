//
//  SignUpManager.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/19/25.
//

import Foundation

// TODO: 회원가입화면2 리팩토링 후 파일 삭제
final class SignUpManager {
    static let shared = SignUpManager()
    private init() {}

    // MARK: - 아이디 중복 확인
    func checkDuplicateId(username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        var components = URLComponents(string: "https://popcorm.store/auth/chkUser")!
        components.queryItems = [URLQueryItem(name: "username", value: username)]

        guard let url = components.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("아이디 중복 확인 요청 실패: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                print("아이디 중복 확인 응답 없음 또는 잘못된 응답")
                completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                return
            }

            if httpResponse.statusCode != 200 {
                let errorMessage = String(data: data, encoding: .utf8) ?? "알 수 없는 오류"
                print("HTTP 상태 코드: \(httpResponse.statusCode), 오류 메시지: \(errorMessage)")
                completion(.failure(NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo: nil)))
                return
            }

            do {
                let responseDict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let resultCode = responseDict?["resultCode"] as? Int ?? -1
                let status = responseDict?["status"] as? String ?? "fail"
                let message = responseDict?["data"] as? String ?? "Unknown error"

                if resultCode == 200 && status == "success" {
                    completion(.success(false))
                } else {
                    completion(.success(true))
                }
            } catch {
                print("아이디 중복 확인 데이터 처리 실패: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

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
    func submitSignupData(signupData: SignUpRequestDTO, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = URL(string: "https://popcorm.store/auth/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(signupData)
            request.httpBody = jsonData

            print("전송하려는 URL: \(request.url?.absoluteString ?? "URL 없음")")
            print("전송하려는 HTTP Method: \(request.httpMethod ?? "HTTP Method 없음")")
            print("전송하려는 헤더:")
            if let headers = request.allHTTPHeaderFields {
                headers.forEach { key, value in
                    print("\(key): \(value)")
                }
            }
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("전송하려는 JSON 데이터: \(jsonString)")
            }
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

            guard let httpResponse = response as? HTTPURLResponse else {
                print("회원가입 응답 없음 또는 잘못된 응답")
                completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                return
            }

            if !(200...299).contains(httpResponse.statusCode) {
                if let data = data, !data.isEmpty {
                    if let errorMessage = String(data: data, encoding: .utf8) {
                        print("회원가입 실패. 상태 코드: \(httpResponse.statusCode), 오류 메시지: \(errorMessage)")
                    } else {
                        print("회원가입 실패. 상태 코드: \(httpResponse.statusCode), 오류 메시지: 응답 데이터를 텍스트로 변환할 수 없습니다.")
                    }
                } else {
                    print("회원가입 실패. 상태 코드: \(httpResponse.statusCode), 오류 메시지: 응답 데이터가 비어 있습니다.")
                }
                completion(.failure(NSError(domain: "ServerError",
                                            code: httpResponse.statusCode,
                                            userInfo: [NSLocalizedDescriptionKey: "회원가입 실패"])))
                return
            }

            completion(.success(true))
        }
        task.resume()
    }

}
