//
//  PopupOverviewViewController.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 3/16/25.
//

import UIKit

final class PopupOverviewViewController: UIViewController {
    private let viewModel: PopupOverviewViewModel
    private let popupOverviewTableview: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 160
        return tableView
    }()

    init(viewModel: PopupOverviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureInitialSetting()
        configureSubviews()
        configureLayout()
        bind(to: viewModel)
        viewModel.generateMockData()
    }

    func bind(to viewModel: PopupOverviewViewModel) {
        viewModel.popupOverviewPublisher = { [weak self] in
            guard let self else { return }
            self.popupOverviewTableview.reloadData()
        }
    }
}

// MARK: - Configure Initial Setting
extension PopupOverviewViewController {
    private func configureInitialSetting() {
        view.backgroundColor = .white

        popupOverviewTableview.dataSource = self
        popupOverviewTableview.delegate = self
        popupOverviewTableview.prefetchDataSource = self

        popupOverviewTableview.register(
            PopupOverviewTableViewCell.self,
            forCellReuseIdentifier: PopupOverviewTableViewCell.reuseIdentifier
        )
    }
}

// MARK: - Implement UITableViewDataSourcePrefetching
extension PopupOverviewViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let itemCount = viewModel.numberOfItems()

        for indexPath in indexPaths {
            if itemCount - 1 == indexPath.row {
                viewModel.fetchMore()
            }
        }
    }
}

// MARK: - Implement UITableView DataSource
extension PopupOverviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PopupOverviewTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? PopupOverviewTableViewCell else {
            return UITableViewCell()
        }
        let data = viewModel.item(at: indexPath.row)

        viewModel.fetchImage(url: data.popupImageUrl) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageData):
                    if let image = UIImage(data: imageData) {
                        cell.configureContents(data, image: image)
                    }
                case .failure:
                    cell.configureContents(data, image: UIImage(resource: .popupPreviewPlaceHolder))
                }
            }

        }

        return cell
    }
}

// MARK: - Implement UITableview Delegate
extension PopupOverviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.item(at: indexPath.row)

        let popupDetailViewController = PopupDetailViewController(
            viewModel: DIContainer.shared.resolve(PopupDetailViewModel.self),
            popupId: data.popupId
        )

        navigationController?.pushViewController(popupDetailViewController, animated: true)
    }
}

// MARK: - Configure UI
extension PopupOverviewViewController {
    private func configureSubviews() {
        view.addSubview(popupOverviewTableview)
        popupOverviewTableview.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            popupOverviewTableview.topAnchor.constraint(equalTo: safeArea.topAnchor),
            popupOverviewTableview.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            popupOverviewTableview.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            popupOverviewTableview.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}
