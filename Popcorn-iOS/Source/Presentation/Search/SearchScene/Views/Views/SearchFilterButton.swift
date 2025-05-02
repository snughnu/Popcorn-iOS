//
//  SearchFilterButton.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 5/2/25.
//

import UIKit

final class SearchFilterButton: UIButton {
    init(title: String, image: UIImage? = nil) {
        super.init(frame: .zero)
        configureButtonUI(title, image)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Button UI
extension SearchFilterButton {
    private func configureButtonUI(_ title: String, _ image: UIImage?) {
        guard let baseFont = UIFont(name: RobotoFontName.robotoMedium, size: 16) else { return  }
        let scaleFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: baseFont)

        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(resource: .popcornOrange)
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 14, bottom: 7, trailing: 14)

        if let image = image {
            config.image = image
            config.imagePlacement = .trailing
        }

        config.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([
                .font: scaleFont,
                .foregroundColor: UIColor(.white)
            ])
        )

        self.configuration = config
    }
}
