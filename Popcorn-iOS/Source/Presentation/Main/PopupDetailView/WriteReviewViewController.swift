//
//  WriteReviewViewController.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/12/25.
//

import PhotosUI
import UIKit

final class WriteReviewViewController: UIViewController {
    private let viewModel = WriteReviewViewModel()

    private let popupMainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .imagePlaceHolder)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let popupTitleLabel: UILabel = {
        let label = UILabel()
        label.popcornSemiBold(text: "팝업 제목", size: 15)
        label.numberOfLines = 0
        return label
    }()

    private let popupPeriodLabel: UILabel = {
        let label = UILabel()
        label.popcornMedium(text: "00.00.00~00.00.00", size: 10)
        return label
    }()

    private let userSatisfactionTitleLabel: UILabel = {
        let label = UILabel()
        label.popcornSemiBold(text: "팝업스토어 만족도", size: 15)
        return label
    }()

    private let userStatisfactionRatingView = StarRatingView(starSpacing: 11.63, isUserInteractionEnabled: true)

    private let writeReviewTitleLabel: UILabel = {
        let label = UILabel()
        label.popcornSemiBold(text: "리뷰 작성", size: 15)
        return label
    }()

    private let reviewConstraintTitleLabel: UILabel = {
        let label = UILabel()
        label.popcornMedium(text: "0자 / 최소 10자", size: 13)
        label.textColor = UIColor(resource: .popcornDarkBlueGray)
        return label
    }()

    private lazy var reviewTextView: UITextView = {
        let textView = UITextView()
        textView.text = viewModel.reviewTextViewPlaceHolderText
        textView.textColor = UIColor(resource: .popcornDarkBlueGray)
        textView.font = UIFont(name: RobotoFontName.robotoMedium, size: 15)
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no      // 자동 수정 비활성화
        textView.spellCheckingType = .no       // 맞춤법 검사 비활성화
        textView.smartQuotesType = .no         // 스마트 따옴표 비활성화
        textView.smartDashesType = .no         // 스마트 대시 비활성화
        textView.smartInsertDeleteType = .no   // 스마트 삽입/삭제 비활성화

        textView.backgroundColor = UIColor(resource: .popcornGray4)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(resource: .popcornGray2).cgColor
        textView.cornerRadius(radius: 10)
        return textView
    }()

    private let uploadImageTitleLabel: UILabel = {
        let label = UILabel()
        label.popcornSemiBold(text: "사진 등록", size: 15)
        return label
    }()

    private let uploadImageConstraintTitleLabel: UILabel = {
        let label = UILabel()
        label.popcornMedium(text: "0장 / 최대 10장", size: 13)
        label.textColor = UIColor(resource: .popcornDarkBlueGray)
        return label
    }()

    private let uploadImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let reviewCompleteButton = PopcornOrangeButton(text: "리뷰 등록하기", isEnabled: false)

    // MARK: - Stack View
    private lazy var popupTitlePeriodStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [popupTitleLabel, popupPeriodLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }()

    init(image: UIImage, title: String, period: String) {
        super.init(nibName: nil, bundle: nil)
        popupMainImageView.image = image
        popupTitleLabel.text = title
        popupPeriodLabel.text = period
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureInitialSetting()
        configureSubviews()
        configureLayout()
        configureAction()
        bind(to: viewModel)
    }

    func bind(to viewModel: WriteReviewViewModel) {
        viewModel.isSubmitEnabledPublisher = { [weak self] isSubmitEnable in
            guard let self else { return }

            DispatchQueue.main.async {
                self.reviewCompleteButton.isEnabled = isSubmitEnable
                self.reviewCompleteButton.configuration?.baseBackgroundColor = isSubmitEnable
                ? UIColor(resource: .popcornOrange)
                : UIColor(resource: .popcornGray2)
            }
        }

        viewModel.reviewImagesPublisher = { [weak self] imageCount in
            guard let self else { return }
            DispatchQueue.main.async {
                self.uploadImageConstraintTitleLabel.text = "\(imageCount)장 / 최대 10장"
                self.uploadImageCollectionView.reloadData()
            }
        }
    }
}

// MARK: - Initial Setting
extension WriteReviewViewController {
    private func configureInitialSetting() {
        view.backgroundColor = .white

        configureGestureRecognizer()
        configureCollectionView()
        reviewTextView.delegate = self
        userStatisfactionRatingView.delegate = self
    }

    private func configureCollectionView() {
        uploadImageCollectionView.dataSource = self
        uploadImageCollectionView.delegate = self

        uploadImageCollectionView.register(
            UploadImageCollectionViewCell.self,
            forCellWithReuseIdentifier: UploadImageCollectionViewCell.reuseIdentifier
        )
    }

    private func configureGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(
            target: userStatisfactionRatingView,
            action: #selector(userStatisfactionRatingView.handlePanGesture(_:))
        )
        let tapGesture = UITapGestureRecognizer(
            target: userStatisfactionRatingView,
            action: #selector(userStatisfactionRatingView.handleTapGesture(_:))
        )
        [panGesture, tapGesture].forEach { userStatisfactionRatingView.addGestureRecognizer($0) }
    }
}

// MARK: - Configure Action
extension WriteReviewViewController {
    private func configureAction() {
        reviewCompleteButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.didTapReviewCompleteButton()
        }, for: .touchUpInside)
    }

    private func didTapReviewCompleteButton() {
        viewModel.postReviewData()
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Implement StarRatingView Delegate
extension WriteReviewViewController: StarRatingViewDelegate {
    func didChangeRating(to rating: Float) {
        viewModel.updateRating(rating)
    }
}

// MARK: - Implement UITextView Delegate
extension WriteReviewViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.updateReviewText(textView.text)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == viewModel.reviewTextViewPlaceHolderText {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = viewModel.reviewTextViewPlaceHolderText
            textView.textColor = UIColor(resource: .popcornDarkBlueGray)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - Configure PHPicker
extension WriteReviewViewController: PHPickerViewControllerDelegate {
    private func configuerPHPicker(selectionLimit: Int) {
        var config = PHPickerConfiguration()
        config.selectionLimit = selectionLimit
        config.filter = .images

        let phPickerViewController = PHPickerViewController(configuration: config)
        phPickerViewController.delegate = self
        self.present(phPickerViewController, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        results.forEach { [weak self] result in
            guard let self else { return }
            guard viewModel.provideReviewImagesCount() <= 10 else { return }

            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }

                    if let image = image as? UIImage {
                        self.viewModel.addImage(image)
                    }
                }
            }
        }
    }

    private func presentResetAlert(for index: Int) {
        let alert = UIAlertController(title: "이미지 초기화", message: "해당 이미지를 초기화 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "초기화", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.viewModel.resetImage(at: index)
        })
        present(alert, animated: true)
    }
}

// MARK: - Implement UICollectionView DataSource
extension WriteReviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UploadImageCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? UploadImageCollectionViewCell else {
            return UICollectionViewCell()
        }

        let reviewImage = viewModel.provideReviewImages(at: indexPath.item)
        cell.configureContents(image: reviewImage)

        return cell
    }
}

// MARK: - Implement UICollectionView DelegateFlowLayout
extension WriteReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let height = view.bounds.height * 70 / 852
        let width = height

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = viewModel.provideReviewImages(at: indexPath.item)

        if image != UIImage(resource: .uploadImagePlaceholder) {
            presentResetAlert(for: indexPath.item)
        } else {
            let selectionLimit = 10 - viewModel.provideReviewImagesCount()
            configuerPHPicker(selectionLimit: selectionLimit)
        }
    }
}

// MARK: - Configure UI
extension WriteReviewViewController {
    private func configureSubviews() {
        [
            popupMainImageView,
            popupTitlePeriodStackView,
            userSatisfactionTitleLabel,
            userStatisfactionRatingView,
            writeReviewTitleLabel,
            reviewConstraintTitleLabel,
            reviewTextView,
            uploadImageTitleLabel,
            uploadImageConstraintTitleLabel,
            uploadImageCollectionView,
            reviewCompleteButton
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        let reviewCompleteButtonTopConstraint = reviewCompleteButton.topAnchor.constraint(
            greaterThanOrEqualTo: uploadImageCollectionView.bottomAnchor,
            constant: 64
        )
        let screenHeight = view.bounds.height
        let verticalSpacing = screenHeight >= 800 ? CGFloat(45) : CGFloat(30)

        reviewCompleteButtonTopConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            popupMainImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            popupMainImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 26),
            popupMainImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 50/393),
            popupMainImageView.heightAnchor.constraint(equalTo: popupMainImageView.widthAnchor),

            popupTitlePeriodStackView.leadingAnchor.constraint(
                equalTo: popupMainImageView.trailingAnchor,
                constant: 10
            ),
            popupTitlePeriodStackView.centerYAnchor.constraint(equalTo: popupMainImageView.centerYAnchor),

            userSatisfactionTitleLabel.topAnchor.constraint(
                equalTo: popupMainImageView.bottomAnchor,
                constant: verticalSpacing
            ),
            userSatisfactionTitleLabel.leadingAnchor.constraint(equalTo: popupMainImageView.leadingAnchor),

            userStatisfactionRatingView.topAnchor.constraint(
                equalTo: userSatisfactionTitleLabel.bottomAnchor,
                constant: 20
            ),
            userStatisfactionRatingView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            writeReviewTitleLabel.topAnchor.constraint(
                equalTo: userStatisfactionRatingView.bottomAnchor,
                constant: verticalSpacing
            ),
            writeReviewTitleLabel.leadingAnchor.constraint(equalTo: popupMainImageView.leadingAnchor),
            writeReviewTitleLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            reviewConstraintTitleLabel.centerYAnchor.constraint(equalTo: writeReviewTitleLabel.centerYAnchor),
            reviewConstraintTitleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -27),

            reviewTextView.topAnchor.constraint(equalTo: writeReviewTitleLabel.bottomAnchor, constant: 20),
            reviewTextView.leadingAnchor.constraint(equalTo: popupMainImageView.leadingAnchor),
            reviewTextView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            reviewTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 104/852),

            uploadImageTitleLabel.topAnchor.constraint(equalTo: reviewTextView.bottomAnchor, constant: verticalSpacing),
            uploadImageTitleLabel.leadingAnchor.constraint(equalTo: popupMainImageView.leadingAnchor),
            uploadImageConstraintTitleLabel.trailingAnchor.constraint(
                equalTo: reviewConstraintTitleLabel.trailingAnchor
            ),

            uploadImageConstraintTitleLabel.centerYAnchor.constraint(equalTo: uploadImageTitleLabel.centerYAnchor),

            uploadImageCollectionView.topAnchor.constraint(equalTo: uploadImageTitleLabel.bottomAnchor, constant: 20),
            uploadImageCollectionView.leadingAnchor.constraint(equalTo: popupMainImageView.leadingAnchor),
            uploadImageCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -27),
            uploadImageCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 70/852),

            reviewCompleteButtonTopConstraint,
            reviewCompleteButton.leadingAnchor.constraint(equalTo: popupMainImageView.leadingAnchor),
            reviewCompleteButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -51),
            reviewCompleteButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            reviewCompleteButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 55/852)
        ])
    }
}
