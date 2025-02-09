//
//  PopupListRepository.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/6/25.
//

import Foundation

final class PopupListRepository: PopupListRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol
    let tokenRepository: TokenRepositoryProtocol

    private let popupListSyncQueue = DispatchQueue(label: "com.popcorn.popupListSyncQueue")

    init(
        networkManager: NetworkManagerProtocol = NetworkManager(),
        tokenRepository: TokenRepositoryProtocol
    ) {
        self.networkManager = networkManager
        self.tokenRepository = tokenRepository
    }

    func fetchPopupMainList(completion: @escaping (Result<PopupMainList, Error>) -> Void) {
        guard let token = tokenRepository.fetchAccessToken() else {
            // TODO: TokenRepository에서 access token 만료 시 자동으로 reissue 하는 로직 구현 후 리팩토링
            completion(.failure(NSError(
                domain: "PopupListRepository",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "액세스 토큰 만료"]
            )))
            return
        }

        let dispatchGroup = DispatchGroup()
        var popupMainListResponse: PopupMainListResponseDTO?
        var todayRecommendPopupResponse: TodayRecommendPopupsResponseDTO?
        var capturedError: NetworkError?

        let popupMainListEndpoint = Endpoint<PopupMainListResponseDTO>(
            httpMethod: .get,
            path: APIConstant.popupPath,
            headers: ["Authorization": "Bearer \(token)"]
        )

        let todayRecommendPopupEndpoint = Endpoint<TodayRecommendPopupsResponseDTO>(
            httpMethod: .get,
            path: APIConstant.popupPath
        )

        dispatchGroup.enter()
        networkManager.request(endpoint: popupMainListEndpoint) { [weak self] result in
            guard let self else {
                dispatchGroup.leave()
                return
            }

            self.popupListSyncQueue.async {
                defer { dispatchGroup.leave() }

                if capturedError != nil { return }

                switch result {
                case .success(let response):
                    popupMainListResponse = response
                case .failure(let error):
                    capturedError = error
                }
            }
        }

        dispatchGroup.enter()
        networkManager.request(endpoint: todayRecommendPopupEndpoint) { [weak self] result in
            guard let self else {
                dispatchGroup.leave()
                return
            }

            self.popupListSyncQueue.async {
                defer { dispatchGroup.leave() }

                if capturedError != nil { return }

                switch result {
                case .success(let response):
                    todayRecommendPopupResponse = response
                case .failure(let error):
                    capturedError = error
                }
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            if let error = capturedError {
                completion(.failure(error))
                return
            }

            guard let self,
                  let popupMainListResponse,
                  let todayRecommendPopupResponse else { return }

            let popupMainList = self.convertToPopupMainList(popupMainListResponse, todayRecommendPopupResponse)
            completion(.success(popupMainList))
        }
    }

    func fetchCategorizedPopupList(completion: @escaping (Result<[PopupPreview], NetworkError>) -> Void) {
        // TODO: API 나온 후 구현
    }
}

extension PopupListRepository {
    private func convertToPopupMainList(
        _ mainListResponseDTO: PopupMainListResponseDTO,
        _ todayRecommendResponseDTO: TodayRecommendPopupsResponseDTO
    ) -> PopupMainList {
        let userPickPopups = mainListResponseDTO.userPickPopups.map { $0.toEntity() }

        let userInterestPopups: [UserInterestPopup] = mainListResponseDTO.userInterestPopups.compactMap { key, value in
            guard let interestCategory = InterestCategory(serverValue: key) else { return nil }
            return UserInterestPopup(
                interestCategory: interestCategory,
                popups: value.map { $0.toEntity() }
            )
        }

        let closingSoonPopups = mainListResponseDTO.closingSoonPopups.map { $0.toEntity() }

        return PopupMainList(
            recommandedPopups: todayRecommendResponseDTO.imageUrls,
            userPickPopups: userPickPopups,
            userInterestPopup: userInterestPopups,
            closingSoonPopup: closingSoonPopups
        )
    }
}
