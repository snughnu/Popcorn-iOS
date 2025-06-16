//
//  NetworkError.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/11/24.
//

import Foundation

/// 네트워크 요청 과정에서 발생할 수 있는 모든 에러를 정의합니다.
/// - 요청 생성, 전송, 응답 수신, 디코딩, 서버 오류 응답까지 전 과정을 다룹니다.
enum NetworkError: Error, CustomStringConvertible {
    /// 유효하지 않은 URL 문자열로 인해 URL 생성에 실패한 경우
    case invalidURL

    /// URLSession 네트워크 요청 자체가 실패한 경우 (인터넷 끊김, 타임아웃 등)
    case urlSessionFailed(Error)

    /// response가 HTTPURLResponse로 다운 캐스팅 실패한 경우
    case invalidResponse

    /// 서버가 실패 응답을 반환한 경우 (4xx 또는 5xx)
    /// - code: HTTP 상태 코드
    /// - message: 서버가 전달한 에러 메시지 (Optional)
    case serverError(code: ServerErrorCode, message: String? = nil)

    /// 응답 데이터가 없거나 nil인 경우
    case emptyData

    /// 요청 바디 인코딩(JSON 등)이 실패한 경우
    case encodingFailed(Error)

    /// 응답 데이터를 디코딩(파싱)하는 데 실패한 경우
    case decodingFailed(Error)

    /// 위에서 명시되지 않은 알 수 없는 에러 (디버깅용)
    case unknown(Error? = nil)

    var description: String {
        switch self {
        case .invalidURL:
            return "invalidURL) 예시: URLComponents(string: baseURL) 생성 실패."
        case .urlSessionFailed(let error):
            return "urlSessionFailed) 네트워크 요청 중 URLSession 에러 발생: \(error.localizedDescription)"
        case .invalidResponse:
            return "invalidResponse) 응답 객체가 HTTPURLResponse 형식이 아님. 유효한 HTTP 응답이 아님."
        case let .serverError(code, message):
            return "serverError) 상태 코드: \(code.description), 서버 메시지: \(message ?? "없음")"
        case .emptyData:
            return "emptyData) 응답은 정상적으로 도착했으나, 데이터가 비어 있거나 존재하지 않음."
        case .encodingFailed(let error):
            return "encodingFailed) 요청 바디 인코딩(JSON 변환 등)에 실패: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "decodingFailed) 응답 데이터를 디코딩(파싱) 실패: \(error.localizedDescription)"
        case .unknown(let error):
            return "unknown) 알 수 없는 오류가 발생: \(error?.localizedDescription ?? "정보 없음")"
        }
    }
}

enum ServerErrorCode: Int {
    /// 알 수 없는 서버 오류 (명시되지 않은 상태 코드 대응용)
    case unknown = -1

    /// 클라이언트의 요청이 잘못되어 서버가 처리할 수 없음 (ex. 필드 누락, 파라미터 오류 등)
    case badRequest = 400

    /// 인증 실패 (ex. 토큰 없음, 만료, 잘못된 자격 증명 등)
    case unauthorized = 401

    /// 인증은 되었지만, 해당 리소스에 접근할 권한이 없음
    case forbidden = 403

    /// 요청한 리소스를 서버에서 찾을 수 없음
    case notFound = 404

    var description: String {
        let code = self.rawValue
        switch self {
        case .badRequest:
            return "\(code) Bad Request: 클라이언트 요청이 잘못되어 서버가 처리할 수 없습니다."
        case .unauthorized:
            return "\(code) Unauthorized: 인증 정보가 없거나 유효하지 않습니다."
        case .forbidden:
            return "\(code) Forbidden: 서버가 요청을 이해했지만 권한이 없어 거부되었습니다."
        case .notFound:
            return "\(code) Not Found: 요청한 리소스를 서버에서 찾을 수 없습니다."
        case .unknown:
            return "Unknown: 정의되지 않은 서버 오류입니다."
        }
    }
}
