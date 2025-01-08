//
//  SignUpSecondViewController.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/26/24.
//

import UIKit

class SignUpSecondViewController: UIViewController {
    let signUpSecondView = SignUpSecondView()
    private let screenHeight = UIScreen.main.bounds.height

    override func loadView() {
        view = signUpSecondView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupAddActions()
        setupTextField()
        updateSignUpButtonState()
    }
}

// MARK: - Setup NavigationBar
extension SignUpSecondViewController {
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "회원가입"
        let size = screenHeight * 21/852
        titleLabel.font = UIFont(name: RobotoFontName.robotoSemiBold, size: size)
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
    private func setupAddActions() {
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

// MARK: - Profile Image Button Tapped
extension SignUpSecondViewController {
    private func selectProfileImageButtonTapped() {
        let profilePickerVC = ProfileImagePickerViewController()
        profilePickerVC.selectedImageHandler = { [weak self] selectedImage, selectedColor in
            guard let self = self else { return }
            self.signUpSecondView.profileImageView.image = selectedImage
            self.signUpSecondView.profileImageView.backgroundColor = selectedColor
        }
        present(profilePickerVC, animated: true, completion: nil)
    }
}

// MARK: - Agree Buttons Action selector 함수
extension SignUpSecondViewController {
    private func allAgreeButtonTapped() {
        let isAllSelected = signUpSecondView.allAgreeButton.isSelected
        let newState = !isAllSelected
        signUpSecondView.allAgreeButton.isSelected = newState
        signUpSecondView.firstAgreeButton.isSelected = newState
        signUpSecondView.secondAgreeButton.isSelected = newState

        updateAgreeButtonImages()
        updateSignUpButtonState()
    }

    private func firstAgreeButtonTapped() {
        signUpSecondView.firstAgreeButton.isSelected.toggle()
        updateAllAgreeButtonState()

        updateAgreeButtonImages()
        updateSignUpButtonState()
    }

    private func secondAgreeButtonTapped() {
        signUpSecondView.secondAgreeButton.isSelected.toggle()
        updateAllAgreeButtonState()

        updateAgreeButtonImages()
        updateSignUpButtonState()
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

    private func updateSignUpButtonState() {
        let isSecondAgreeSelected = signUpSecondView.secondAgreeButton.isSelected
        signUpSecondView.signUpButton.isEnabled = isSecondAgreeSelected
        var config = signUpSecondView.signUpButton.configuration
        config?.background.backgroundColor = isSecondAgreeSelected
            ? UIColor(resource: .popcornOrange)
            : UIColor(resource: .popcornGray2)
        signUpSecondView.signUpButton.configuration = config
    }
}

// MARK: - SignUp Button selector 함수
extension SignUpSecondViewController {
    private func signUpButtonTapped() {
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
