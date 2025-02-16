//
//  SignUpSecondViewController.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/26/24.
//

import UIKit

class SignUpSecondViewController: UIViewController {
    // MARK: - Properties
    private let signUpSecondView = SignUpSecondView()
    private var signUpSecondViewModel: SignUpSecondViewModelProtocol
    private let screenHeight = UIScreen.main.bounds.height

    // MARK: - Initializer
    init(
        signUpSecondViewModel: SignUpSecondViewModelProtocol
    ) {
        self.signUpSecondViewModel = signUpSecondViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = signUpSecondView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: signUpSecondViewModel)
        setupAddActions()
        setupTextField()
        setupNavigationBar()
    }
}

// MARK: - Bind func
extension SignUpSecondViewController {
    private func bind(to signUpSecondViewModel: SignUpSecondViewModelProtocol) {
        self.signUpSecondViewModel.profileImageUpdateHandler = { [ weak self ] profileId in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let image: UIImage?
                switch profileId {
                case 0: image = UIImage(resource: .popcornProfile0)
                case 1: image = UIImage(resource: .popcornProfile1)
                case 2: image = UIImage(resource: .popcornProfile2)
                case 3: image = UIImage(resource: .popcornProfile3)
                case 4: image = UIImage(resource: .popcornProfile4)
                default:
                    return
                }
                self.signUpSecondView.profileImageView.image = image
            }
        }

        self.signUpSecondViewModel.agreeStateUpdated = { [ weak self ] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateAgreeButtonUI()
                self.updateSignUpButtonState()
            }
        }

        self.signUpSecondViewModel.signUpResultHandler = { [ weak self ] isSuccess, message in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showAlert(title: isSuccess ? "회원가입 성공" : "회원가입 실패", message: message) {
                    if isSuccess {
                        let loginViewController = DIContainer().makeLoginViewController()
                        self.navigationController?.setViewControllers([loginViewController], animated: true)
                    }
                }
            }
        }
    }
}

// MARK: - Setup AddActions
extension SignUpSecondViewController {
    private func setupAddActions() {
        signUpSecondView.selectProfileImageButton.addAction(UIAction { _ in
            self.selectProfileImageButtonTapped()
        }, for: .touchUpInside)

        signUpSecondView.allAgreeButton.addAction(UIAction { _ in
            self.signUpSecondViewModel.toggleAllAgree()
        }, for: .touchUpInside)

        signUpSecondView.firstAgreeButton.addAction(UIAction { _ in
            self.signUpSecondViewModel.toggleFirstAgree()
        }, for: .touchUpInside)

        signUpSecondView.secondAgreeButton.addAction(UIAction { _ in
            self.signUpSecondViewModel.toggleSecondAgree()
        }, for: .touchUpInside)

        signUpSecondView.signUpButton.addAction(UIAction { _ in
            self.signUpButtonTapped()
        }, for: .touchUpInside)
    }

    private func selectProfileImageButtonTapped() {
        let profilePickerViewController = ProfileImagePickerViewController()
        profilePickerViewController.selectedImageHandler = { [ weak self ] _, selectedIndex in
            guard let self = self else { return }
            guard let selectedIndex = selectedIndex else { return }
            self.signUpSecondViewModel.updateSelectedProfile(index: selectedIndex)
        }
        present(profilePickerViewController, animated: true)
    }

    private func signUpButtonTapped() {
        guard let nickName = signUpSecondView.nickNameTextField.text, !nickName.isEmpty else {
            showAlert(title: "입력 오류", message: "닉네임을 입력해주세요.")
            return
        }

        signUpSecondViewModel.updateSelectedInterests(signUpSecondView.selectedInterests)
        signUpSecondViewModel.sendSignUpData(nickName: nickName)
    }

    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in completion?() })
        present(alert, animated: true)
    }
}

// MARK: - Update button UI func
extension SignUpSecondViewController {
    private func updateAgreeButtonUI() {
        signUpSecondView.allAgreeButton.isSelected = signUpSecondViewModel.isAllAgreed
        signUpSecondView.firstAgreeButton.isSelected = signUpSecondViewModel.isFirstAgreed
        signUpSecondView.secondAgreeButton.isSelected = signUpSecondViewModel.isSecondAgreed

        let allAgreeImage = signUpSecondViewModel.isAllAgreed
            ? UIImage(resource: .checkButtonSelected)
            : UIImage(resource: .checkButton)
        signUpSecondView.allAgreeButton.setImage(allAgreeImage, for: .normal)

        let firstAgreeImage = signUpSecondViewModel.isFirstAgreed
            ? UIImage(resource: .individualCheckButtonSelected)
            : UIImage(resource: .individualCheckButton)
        signUpSecondView.firstAgreeButton.setImage(firstAgreeImage, for: .normal)

        let secondAgreeImage = signUpSecondViewModel.isSecondAgreed
            ? UIImage(resource: .individualCheckButtonSelected)
            : UIImage(resource: .individualCheckButton)
        signUpSecondView.secondAgreeButton.setImage(secondAgreeImage, for: .normal)
    }

    private func updateSignUpButtonState() {
        let isSecondAgreeSelected = signUpSecondViewModel.isSecondAgreed
        signUpSecondView.signUpButton.isEnabled = isSecondAgreeSelected
        var config = signUpSecondView.signUpButton.configuration
        config?.background.backgroundColor = isSecondAgreeSelected
            ? UIColor(resource: .popcornOrange)
            : UIColor(resource: .popcornGray2)
        signUpSecondView.signUpButton.configuration = config
    }
}

// MARK: - TextField Delegate Protocol
extension SignUpSecondViewController: UITextFieldDelegate {
    private func setupTextField() {
        signUpSecondView.nickNameTextField.delegate = self
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

// MARK: - Setup NavigationBar
extension SignUpSecondViewController {
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "회원가입"
        titleLabel.font = UIFont(name: RobotoFontName.robotoSemiBold, size: screenHeight * 21/852)
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
