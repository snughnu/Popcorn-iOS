//
//  SearchViewController.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 4/14/25.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - Properties
    private let searchView = SearchView()
    private let searchBottomSheetViewController = SearchBottomSheetViewController()

    // MARK: - Bottom Sheet Properties
    private var bottomSheetTopOffsetConstraint: NSLayoutConstraint?
    private var topOffsetWhenOpened: CGFloat {
        return view.bounds.height * 130 / 852
    }
    private var topOffsetWhenClosed: CGFloat {
        return view.bounds.height * 606 / 852
    }
    private var bottomSheetHeight: CGFloat {
        return view.bounds.height * 668 / 852
    }
    private var hasAddedBottomSheet = false

    // MARK: - Initializer
    override func loadView() {
        view = searchView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !hasAddedBottomSheet {
            hasAddedBottomSheet = true
            addBottomSheet()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: - Bottom Sheet Methods
extension SearchViewController {
    private func addBottomSheet() {
        addChild(searchBottomSheetViewController)
        view.addSubview(searchBottomSheetViewController.view)
        searchBottomSheetViewController.didMove(toParent: self)

        let sheetView = searchBottomSheetViewController.view!
        sheetView.translatesAutoresizingMaskIntoConstraints = false

        let top = sheetView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: topOffsetWhenClosed
        )
        bottomSheetTopOffsetConstraint = top

        NSLayoutConstraint.activate([
            top,
            sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetView.heightAnchor.constraint(equalToConstant: bottomSheetHeight)
        ])

        let bottomSheetPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        sheetView.addGestureRecognizer(bottomSheetPanGesture)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let topConstraint = bottomSheetTopOffsetConstraint else { return }
        let translation = gesture.translation(in: view)
        gesture.setTranslation(.zero, in: view)

        switch gesture.state {
        case .changed:
            topConstraint.constant += translation.y
            topConstraint.constant = max(topOffsetWhenOpened, min(topOffsetWhenClosed, topConstraint.constant))
            view.layoutIfNeeded()

        case .ended:
            let velocity = gesture.velocity(in: view).y
            let mid = (topOffsetWhenClosed + topOffsetWhenOpened) / 2
            let target = (velocity > 0 || topConstraint.constant > mid) ? topOffsetWhenClosed : topOffsetWhenOpened
            animateBottomSheet(to: target)

        default:
            break
        }
    }

    private func animateBottomSheet(to constant: CGFloat) {
        bottomSheetTopOffsetConstraint?.constant = constant
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
            self.view.layoutIfNeeded()
        }
    }
}
