//
//  FetchPopupListUseCaseProtocol.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/9/25.
//

protocol FetchPopupListUseCaseProtocol {
    func fetchPopupMainList(completion: @escaping (Result<PopupMainList, Error>) -> Void)
    func fetchCategorizedPopupList(completion: @escaping (Result<[PopupPreview], NetworkError>) -> Void)
}
