//
//  NetworkError.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/11/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL                       // 유효하지 않은 URL
    case responseError                    // 유효하지 않은 응답값일 경우
    case decodingError(Error)             // 데이터 파싱 실패
    case emptyData                        // 응답 데이터가 비어있는 경우
    case serverError(ServerError)         // 서버 에러
    case requestFailed(String)            // 서버 요청 실패한 경우
    case unknown                          // 알 수 없는 오류

    var description: String {
        switch self {
        case .invalidURL:
            "URL이 올바르지 않습니다."
        case .responseError:
            "응답값이 유효하지 않습니다."
        case .decodingError(let description):
            "디코딩 에러: \(description)"
        case .emptyData:
            "데이터가 없습니다."
        case .serverError(let code):
            "서버 에러 \(code.rawValue)"
        case .requestFailed(let message):
            "서버 요청 실패 \(message)"
        case .unknown:
            "알 수 없는 에러"
        }
    }
}

enum ServerError: Int {
    case unknown = -1           // 알 수 없는 오류
    case badRequest = 400       // 잘못된 요청
    case unauthorized = 401     // 인증 실패
    case forbidden = 403        // 접근 권한 없음
    case notFound = 404         // 요청한 리소스를 찾을 수 없음
}
