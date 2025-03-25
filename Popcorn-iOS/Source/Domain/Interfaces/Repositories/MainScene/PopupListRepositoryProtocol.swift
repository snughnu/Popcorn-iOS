//
//  PopupListRepositoryProtocol.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/5/25.
//

protocol PopupListRepositoryProtocol {
    func fetchPopupMainList(completion: @escaping (Result<PopupMainList, Error>) -> Void)
    func fetchPopupOverview(
        category: PopupSectionCategory,
        page: Int,
        completion: @escaping (Result<[PopupOverview], Error>) -> Void
    )
}
