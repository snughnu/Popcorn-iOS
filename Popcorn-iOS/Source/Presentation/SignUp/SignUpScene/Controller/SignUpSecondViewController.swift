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
        setupNavigationBar()
        setupAddActions()
        setupTextField()
    }
}

// MARK: - Setup NavigationBar
extension SignUpSecondViewController {
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "회원가입"
        titleLabel.font = UIFont(name: RobotoFontName.robotoSemiBold, size: 21)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
        navigationItem.hidesBackButton = true
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(resource: .naviBackButton), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 20
        navigationItem.leftBarButtonItems = [spacer, leftBarButtonItem]
    }

    @objc private func backButtonTapped() {
       navigationController?.popViewController(animated: true)
    }
}

// MARK: - Setup AddActions
extension SignUpSecondViewController {
    func setupAddActions() {
        signUpSecondView.selectProfileImageButton.addAction(UIAction { _ in
            self.selectProfileImageButtonTapped()
        }, for: .touchUpInside)

        signUpSecondView.allAgreeButton.addAction(UIAction { _ in
            self.allAgreeButtonTapped()
        }, for: .touchUpInside)

        signUpSecondView.firstAgreeButton.addAction(UIAction { _ in
            self.firstAgreeButtonTapped()
        }, for: .touchUpInside)

        signUpSecondView.secondAgreeButton.addAction(UIAction { _ in
            self.secondAgreeButtonTapped()
        }, for: .touchUpInside)

        signUpSecondView.signUpButton.addAction(UIAction { _ in
            self.signUpButtonTapped()
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

// MARK: - Agree Buttons Action selector 함수
extension SignUpSecondViewController {
    @objc func allAgreeButtonTapped() {
        let isAllSelected = signUpSecondView.allAgreeButton.isSelected
        let newState = !isAllSelected
        signUpSecondView.allAgreeButton.isSelected = newState
        signUpSecondView.firstAgreeButton.isSelected = newState
        signUpSecondView.secondAgreeButton.isSelected = newState

        updateAgreeButtonImages()
    }

    @objc func firstAgreeButtonTapped() {
        signUpSecondView.firstAgreeButton.isSelected.toggle()
        updateAllAgreeButtonState()

        updateAgreeButtonImages()
    }

    @objc func secondAgreeButtonTapped() {
        signUpSecondView.secondAgreeButton.isSelected.toggle()
        updateAllAgreeButtonState()

        updateAgreeButtonImages()
    }

    private func updateAllAgreeButtonState() {
        let isAllAgreed = signUpSecondView.firstAgreeButton.isSelected &&
                          signUpSecondView.secondAgreeButton.isSelected
        signUpSecondView.allAgreeButton.isSelected = isAllAgreed
    }

    private func updateAgreeButtonImages() {
        let allAgreeImage = signUpSecondView.allAgreeButton.isSelected
            ? UIImage(resource: .checkButtonSelected)
            : UIImage(resource: .checkButton)
        signUpSecondView.allAgreeButton.setImage(allAgreeImage, for: .normal)

        let firstAgreeImage = signUpSecondView.firstAgreeButton.isSelected
            ? UIImage(resource: .individualCheckButtonSelected)
            : UIImage(resource: .individualCheckButton)
        signUpSecondView.firstAgreeButton.setImage(firstAgreeImage, for: .normal)

        let secondAgreeImage = signUpSecondView.secondAgreeButton.isSelected
            ? UIImage(resource: .individualCheckButtonSelected)
            : UIImage(resource: .individualCheckButton)
        signUpSecondView.secondAgreeButton.setImage(secondAgreeImage, for: .normal)
    }
}

// MARK: - SignUp Button selector 함수
extension SignUpSecondViewController {
    @objc func signUpButtonTapped() {
        // TODO: 서버와 통신
        let loginViewController = LoginViewController()
        self.navigationController?.setViewControllers([loginViewController], animated: true)
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
