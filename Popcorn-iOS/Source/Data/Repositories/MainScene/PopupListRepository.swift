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

    init(networkManager: NetworkManagerProtocol, tokenRepository: TokenRepositoryProtocol) {
        self.networkManager = networkManager
        self.tokenRepository = tokenRepository
    }

    func fetchPopupMainList(completion: @escaping (Result<(data: PopupMainList, hasNextPage: Bool), Error>) -> Void) {
        guard let token = tokenRepository.fetchAccessToken() else {
            // TODO: TokenRepository에서 access token 만료 시 자동으로 reissue 하는 로직 구현 후 리팩토링
            completion(.failure(NSError(
                domain: "PopupListRepository",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "액세스 토큰 만료"]
            )))
            return
        }

        let popupMainListEndpoint = Endpoint<PopupMainListResponseDTO>(
            httpMethod: .get,
            path: APIConstant.mainScenePath,
            queryItems: [URLQueryItem(name: "page", value: "1")],
            headers: ["Authorization": "Bearer \(token)"]
        )

        networkManager.request(endpoint: popupMainListEndpoint) { [weak self] result in
            guard let self else { return }
            print(result)
            switch result {
            case .success(let response):
                let hasNextPage = response.currentPages < response.totalPages
                let popupMainList = self.convertToPopupMainList(response)
                completion(.success((popupMainList, hasNextPage)))
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchClosingSoonPopup(
        page: Int,
        completion: @escaping (Result<(data: [PopupPreview], hasNextPage: Bool), Error>) -> Void
    ) {
        guard let token = tokenRepository.fetchAccessToken() else {
            // TODO: TokenRepository에서 access token 만료 시 자동으로 reissue 하는 로직 구현 후 리팩토링
            completion(.failure(NSError(
                domain: "PopupListRepository",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "액세스 토큰 만료"]
            )))
            return
        }

        let closingSoonPopupEndpoint = Endpoint<ClosingSoonPopupResponseDTO>(
            httpMethod: .get,
            path: APIConstant.mainScenePath,
            queryItems: [URLQueryItem(name: "page", value: String(page))],
            headers: ["Authorization": "Bearer \(token)"]
        )

        networkManager.request(endpoint: closingSoonPopupEndpoint) { result in
            switch result {
            case .success(let response):
                let popups = response.popups.map { $0.toEntity() }
                let hasNextPage = response.currentPages < response.totalPages
                completion(.success((popups, hasNextPage)))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }

    func fetchPopupOverview(
        category: PopupSectionCategory,
        page: Int,
        completion: @escaping (Result<[PopupOverview], Error>) -> Void
    ) {
        guard let token = tokenRepository.fetchAccessToken() else {
            // TODO: TokenRepository에서 access token 만료 시 자동으로 reissue 하는 로직 구현 후 리팩토링
            completion(.failure(NSError(
                domain: "PopupListRepository",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "액세스 토큰 만료"]
            )))
            return
        }

        if case .userPick = category {
            let userPickOverviewEndpoint = Endpoint<[PopupOverviewResponseDTO]>(
                httpMethod: .get,
                path: APIConstant.userPickOverviewPath,
                queryItems: [URLQueryItem(name: "page", value: String(page))],
                headers: ["Authorization": "Bearer \(token)"]
            )

            networkManager.request(endpoint: userPickOverviewEndpoint) { result in
                switch result {
                case .success(let endpoint):
                    completion(.success(endpoint.map { $0.toEntity() }))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else if case .userInterest(let interestCategory) = category {
            guard let interestCategory else {
                print("관심사 카테고리가 옵셔널 타입입니다.")
                return
            }

            let interestCategoryString: String = InterestCategoryDTO(from: interestCategory).category
            let interestOverviewEndpoint = Endpoint<[PopupOverviewResponseDTO]>(
                httpMethod: .get,
                path: APIConstant.interestOverviewPath(category: interestCategoryString),
                queryItems: [URLQueryItem(name: "page", value: String(page))],
                headers: ["Authorization": "Bearer \(token)"]
            )

            networkManager.request(endpoint: interestOverviewEndpoint) { result in
                switch result {
                case .success(let endpoint):
                    completion(.success(endpoint.map { $0.toEntity() }))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

extension PopupListRepository {
    private func convertToPopupMainList(
        _ mainListResponseDTO: PopupMainListResponseDTO
    ) -> PopupMainList {
        let recommendedPopups = mainListResponseDTO.todayRecommendPopups.map { $0.toEntity() }
        let userPickPopups = mainListResponseDTO.userPickPopups.map { $0.toEntity() }

        let userInterestPopups: [UserInterestPopup] = mainListResponseDTO.userInterestPopups.compactMap { key, value in
            guard let interestCategory = key.toEntity() else { return nil }
            return UserInterestPopup(
                interestCategory: interestCategory,
                popups: value.map { $0.toEntity() }
            )
        }

        let closingSoonPopups = mainListResponseDTO.closingSoonPopups.map { $0.toEntity() }

        return PopupMainList(
            recommendedPopups: recommendedPopups,
            userPickPopups: userPickPopups,
            userInterestPopup: userInterestPopups,
            closingSoonPopup: closingSoonPopups
        )
    }
}
