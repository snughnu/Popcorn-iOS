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
        setupTextField()
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

// MARK: - Image Picker Delegate Protocol
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

// MARK: - TextField Delegate Protocol
extension SignUpSecondViewController: UITextFieldDelegate {
    private func setupTextField() {
        [
            signUpSecondView.nickNameTextField
        ].forEach {
            $0.delegate = self
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == signUpSecondView.nickNameTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray3)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == signUpSecondView.nickNameTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray4)
        }
    }
}
