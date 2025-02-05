//
//  ImageFetchError.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/5/25.
//

enum ImageFetchError: Error {
    case invalidURL                       // 유효하지 않은 URL
    case emptyData                        // 응답 데이터가 비어있는 경우
    case networkError                     // 네트워크 에러 발생

    var description: String {
        switch self {
        case .invalidURL:
            "URL이 올바르지 않습니다."
        case .emptyData:
            "이미지 데이터가 없습니다."
        case .networkError:
            "이미지 로드 중 네트워크 에러 발생"
        }
    }
}
