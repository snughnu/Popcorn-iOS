//
//  PopupDetailRepository.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/20/25.
//

import Foundation

final class PopupDetailRepository: PopupDetailRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol
    private let tokenRepository: TokenRepositoryProtocol

    init(
        networkManager: NetworkManagerProtocol = NetworkManager(),
        tokenRepository: TokenRepositoryProtocol = TokenRepository(
            networkManager: NetworkManager(),
            keychainManager: KeychainManager()
        )
    ) {
        self.networkManager = networkManager
        self.tokenRepository = tokenRepository
    }

    func fetchPopupAllData(
        popupId: Int,
        completion: @escaping (Result<(PopupInformation, PopupRatingDistribution, PopupReviewList), any Error>
        ) -> Void) {
        // TODO: TokenRepository에서 access token 만료 시 자동으로 reissue 하는 로직 구현 후 리팩토링
        guard let token = tokenRepository.fetchAccessToken() else {
            completion(.failure(NSError(
                domain: "PopupDetailRepository",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "액세스 토큰 만료"]
            )))
            return
        }

        let dispatchGroup = DispatchGroup()
        var capturedErrors = [NetworkError]()
        let lock = NSLock()

        var popupInformationResponse: PopupInformationResponseDTO?
        var popupRatingDistributionResponse: PopupRatingDistributionResponseDTO?
        var popupReviewListResponse: PopupReviewListResponseDTO?

        let popupInformationEndpoint = Endpoint<PopupInformationResponseDTO>(
            httpMethod: .get,
            path: APIConstant.popupDetailPath(popupId: APIConstant.popupDetailPath(popupId: String(popupId))),
            headers: ["Authorization": "Bearer \(token)"]
        )

        let popupRatingDistributionEndpoint = Endpoint<PopupRatingDistributionResponseDTO>(
            httpMethod: .get,
            path: APIConstant.popupRatingPath(popupId: String(popupId))
        )

        let popupReviewListEndpoint = Endpoint<PopupReviewListResponseDTO>(
            httpMethod: .get,
            path: APIConstant.popupReviewPath(popupId: String(popupId)),
            queryItems: [URLQueryItem(name: "page", value: "1")],
            headers: ["Authorization": "Bearer \(token)"]
        )

        dispatchGroup.enter()
        networkManager.request(endpoint: popupInformationEndpoint) { result in
            lock.lock()
            defer {
                lock.unlock()
                dispatchGroup.leave()
            }

            if !capturedErrors.isEmpty { return }

            switch result {
            case .success(let response):
                popupInformationResponse = response
            case .failure(let error):
                capturedErrors.append(error)
            }
        }

        dispatchGroup.enter()
        networkManager.request(endpoint: popupRatingDistributionEndpoint) { result in
            lock.lock()
            defer {
                lock.unlock()
                dispatchGroup.leave()
            }

            if !capturedErrors.isEmpty { return }

            switch result {
            case .success(let response):
                popupRatingDistributionResponse = response
            case .failure(let error):
                capturedErrors.append(error)
            }
        }

        dispatchGroup.enter()
        networkManager.request(endpoint: popupReviewListEndpoint) { result in
            lock.lock()
            defer {
                lock.unlock()
                dispatchGroup.leave()
            }

            if !capturedErrors.isEmpty { return }

            switch result {
            case .success(let response):
                popupReviewListResponse = response
            case .failure(let error):
                capturedErrors.append(error)
            }
        }

        dispatchGroup.notify(queue: .main) {
            if !capturedErrors.isEmpty {
                let combinedError = NSError(
                    domain: "PopupDetailRepsitory",
                    code: -2,
                    userInfo: [
                        NSLocalizedDescriptionKey: "상세화면 데이터 요청 실패",
                        "error": capturedErrors
                    ]
                )

                completion(.failure(combinedError))
                return
            }

            guard let popupInformationResponse,
                  let popupRatingDistributionResponse,
                  let popupReviewListResponse else { return }

            let popupReviewList = PopupReviewList(reviews: popupReviewListResponse.reviews.map { $0.toEntity() })

            completion(.success((
                popupInformationResponse.toEntity(),
                popupRatingDistributionResponse.toEntity(),
                popupReviewList
            )))
        }
    }

    func fetchPopupReviews(
        popupId: Int,
        page: Int,
        completion: @escaping (Result<PopupReviewList, any Error>
        ) -> Void) {
        // TODO: TokenRepository에서 access token 만료 시 자동으로 reissue 하는 로직 구현 후 리팩토링
        guard let token = tokenRepository.fetchAccessToken() else {
            completion(.failure(NSError(
                domain: "PopupDetailRepository",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "액세스 토큰 만료"]
            )))
            return
        }

        let endpoint = Endpoint<PopupReviewListResponseDTO>(
            httpMethod: .get,
            path: APIConstant.popupReviewPath(popupId: String(popupId)),
            queryItems: [URLQueryItem(name: "page", value: String(page))],
            headers: ["Authorization": "Bearer \(token)"]
        )

        networkManager.request(endpoint: endpoint) { result in
            switch result {
            case .success(let response):
                let reviewList = response.reviews.map { $0.toEntity() }
                completion(.success(PopupReviewList(reviews: reviewList)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
