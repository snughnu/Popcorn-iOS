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

    override func loadView() {
        view = searchBottomSheetView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
