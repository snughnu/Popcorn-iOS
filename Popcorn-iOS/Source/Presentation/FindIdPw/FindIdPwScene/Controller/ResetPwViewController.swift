//
//  ResetPwViewController.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 12/30/24.
//

import UIKit

class ResetPwViewController: UIViewController {
    private let resetPwView = ResetPwView()
    private let screenHeight = UIScreen.main.bounds.height

    override func loadView() {
        view = resetPwView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupAddActions()
        setupTextField()
        setUpKeyboard()
    }
}

// MARK: - Setup NavigationBar
extension ResetPwViewController {
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "아이디/비밀번호 찾기"
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
extension ResetPwViewController {
    private func setupAddActions() {
        resetPwView.selectProfileImageButton.addAction(UIAction { _ in
            self.selectProfileImageButtonTapped()
        }, for: .touchUpInside)

        resetPwView.completeButton.addAction(UIAction { _ in
            self.completeButtonTapped()
        }, for: .touchUpInside)
    }
}

// MARK: - Image Picker Delegate Protocol
extension ResetPwViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func selectProfileImageButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            resetPwView.profileImageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - SignUp Button selector 함수
extension ResetPwViewController {
    private func completeButtonTapped() {
        // TODO: 서버와 통신
        let loginViewController = LoginViewController()
        self.navigationController?.setViewControllers([loginViewController], animated: true)
    }
}

// MARK: - TextField Delegate Protocol
extension ResetPwViewController: UITextFieldDelegate {
    private func setupTextField() {
        [
            resetPwView.nickNameTextField,
            resetPwView.pwTextField,
            resetPwView.emailTextField
        ].forEach {
            $0.delegate = self
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == resetPwView.nickNameTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray3)
        }
        if textField == resetPwView.pwTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray3)
        }
        if textField == resetPwView.emailTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray3)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == resetPwView.nickNameTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray4)
        }
        if textField == resetPwView.pwTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray4)
        }
        if textField == resetPwView.emailTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray4)
        }
    }
}

// MARK: - Setup Keyboard
extension ResetPwViewController {
    private func setUpKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc func keyboardWillShow(_ sender: Notification) {
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentResponder as? UITextField else { return }

        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height

        if textFieldBottomY > keyboardTopY {
            let textFieldTopY = convertedTextFieldFrame.origin.y
            let newFrame = textFieldTopY - keyboardTopY/1.6
            view.frame.origin.y = -newFrame
        }
    }

    @objc func keyboardWillHide(_ sender: Notification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
}
