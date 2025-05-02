//
//  SearchBottomSheetViewController.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 4/14/25.
//

import UIKit

class SearchBottomSheetViewController: UIViewController {
    // MARK: - Properties
    private let searchBottomSheetView = SearchBottomSheetView()

    // MARK: - 임시 더미 데이터
    private var popupData: [String] = [
        "팝업스토어 1", "팝업스토어 2", "팝업스토어 3"
    ]

    override func loadView() {
        view = searchBottomSheetView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    private func configureTableView() {
        let tableView = searchBottomSheetView.tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            SearchPopupTableViewCell.self,
            forCellReuseIdentifier: SearchPopupTableViewCell.reuseIdentifier
        )
    }
}

// MARK: - Configure TableView, Cell
extension SearchBottomSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popupData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchPopupTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? SearchPopupTableViewCell else {
            return UITableViewCell()
        }

        // 임시 데이터
        let title = popupData[indexPath.row]
        let image = UIImage(resource: .popup)
        let distance = "416m"
        let period = "24.11.04 ~ 24.11.17"

        cell.configurePopupData(image: image, title: title, distance: distance, period: period)
        return cell
    }
}

// MARK: - 셀 선택 처리
extension SearchBottomSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("선택된 셀: \(popupData[indexPath.row])")
    }
}
