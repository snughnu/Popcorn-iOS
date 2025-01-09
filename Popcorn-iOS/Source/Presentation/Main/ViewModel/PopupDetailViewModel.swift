final class PopupDetailViewModel: MainCarouselViewModelProtocol {
    var carouselPopupImage: [UIImage] = [] {
        didSet {
            carouselImagePublisher?()
        }
    }
    // MARK: - Output
    var carouselImagePublisher: (() -> Void)?
}
// MARK: - Implement MainCarouselViewModelProtocol
extension PopupDetailViewModel {
    func provideCarouselImage() -> [UIImage] {
        return carouselPopupImage
    }

    func numbersOfCarouselImage() -> Int {
        return carouselPopupImage.count
    }
}
