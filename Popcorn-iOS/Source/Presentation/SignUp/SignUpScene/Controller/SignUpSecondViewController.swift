//
//  SignUpSecondViewController.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/26/24.
//

import UIKit

class SignUpSecondViewController: UIViewController {
    private let signUpSecondView = SignUpSecondView()

    override func loadView() {
        view = signUpSecondView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddActions()
    }

}

// MARK: - Setup AddActions
extension SignUpSecondViewController {
    func setupAddActions() {
        signUpSecondView.selectProfileImageButton.addAction(UIAction { _ in
            self.selectProfileImageButtonTapped()
        }, for: .touchUpInside)
    }
}

// MARK: - 이미지피커 프로토콜사용
extension SignUpSecondViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func selectProfileImageButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            signUpSecondView.profileImageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
