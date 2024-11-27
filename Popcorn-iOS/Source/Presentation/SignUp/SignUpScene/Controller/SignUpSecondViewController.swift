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

// MARK: - selector 함수
extension SignUpSecondViewController {
    @objc func signUpButtonTapped() {
        // TODO: 서버와 통신
        let loginViewController = LoginViewController()
        self.navigationController?.setViewControllers([loginViewController], animated: true)
    }

    @objc func allAgreeButtonTapped() {
        // TODO: 동의버튼 눌렀을 때 동작
        /*
        모두 선택되어 있지 않을 때, 전체 동의를 누를 때 모든 체크박스가 on 상태가 된다
        모두 선택되어 있을 때, 전체 동의를 누르면 모든 체크박스가 off 상태가 된다.
        모두 선택되어 있을 때, 전체 동의하기 체크박스는 on 상태이다.
        모두 선택되어 있을 때, 전체 동의를 제외한 체크박스 하나를 누르면 전체 동의하기 체크박스는 해제된다.
        */
    }

    @objc func firstAgreeButtonTapped() {

    }

    @objc func secondAgreeButtonTapped() {

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
