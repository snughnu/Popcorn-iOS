//
//  PopupListRepositoryProtocol.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/5/25.
//

protocol PopupListRepositoryProtocol {
    func fetchPopupMainList(completion: @escaping (Result<PopupMainList, NetworkError>) -> Void)
    func fetchCategorizedPopupList(completion: @escaping (Result<[PopupPreview], NetworkError>) -> Void)
}
