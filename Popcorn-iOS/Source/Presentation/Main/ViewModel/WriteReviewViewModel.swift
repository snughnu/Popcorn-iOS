//
//  WriteReviewViewModel.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/20/25.
//

import UIKit

final class WriteReviewViewModel {
    let reviewTextViewPlaceHolderText = "팝업스토어 리뷰를 남겨주세요."

    private var rating: Float = 0 {
        didSet {
            validateSubmitEnabled()
        }
    }

    private var reviewText: String = "" {
        didSet {
            validateSubmitEnabled(text: reviewText)
        }
    }

    private var reviewImages: [UIImage] = [] {
        didSet {
            validateSubmitEnabled()
            reviewImagesPublisher?(reviewImages.count)
        }
    }

    private var isSubmitEnabled: Bool = false {
        didSet {
            isSubmitEnabledPublisher?(isSubmitEnabled)
        }
    }

    // MARK: - Output
    var isSubmitEnabledPublisher: ((_ isSubmitEnabled: Bool) -> Void)?
    var reviewImagesPublisher: ((_ imageCount: Int) -> Void)?

    private func validateSubmitEnabled(text: String = "") {
        let isRatingValid = rating > 0 && rating <= 5
        let isTextValid = text != reviewTextViewPlaceHolderText && (reviewText.count > 10)
        let isImageValid = reviewImages.count <= 10

        isSubmitEnabled = isRatingValid && isTextValid && isImageValid
    }
}

// MARK: - Public Interface
extension WriteReviewViewModel {
    func provideReviewImages(at index: Int) -> UIImage {
        guard index < reviewImages.count else { return UIImage(resource: .uploadImagePlaceholder) }
        return reviewImages[index]
    }

    func provideReviewImagesCount() -> Int {
        return reviewImages.count
    }

    func resetImage(at index: Int) {
        guard index >= 0 && index < reviewImages.count else { return }
        reviewImages.remove(at: index)
    }
}

// MARK: - Input
extension WriteReviewViewModel {
    func updateRating(_ rating: Float) {
        self.rating = rating
    }

    func updateReviewText(_ text: String) {
        self.reviewText = text
    }

    func addImage(_ image: UIImage) {
        reviewImages.append(image)
    }
}

// MARK: - Network
extension WriteReviewViewModel {
    func postReviewData() {
        print(rating, reviewText, reviewImages)
    }
}
