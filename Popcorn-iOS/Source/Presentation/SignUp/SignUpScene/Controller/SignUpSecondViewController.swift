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
    private var selectedProfileId: Int?

    override func loadView() {
        view = signUpSecondView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        SignUpInterestButton.selectedButtons = []
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
        profilePickerVC.selectedImageHandler = { [weak self] selectedImage, selectedColor, selectedIndex in
            guard let self = self else { return }
            self.signUpSecondView.profileImageView.image = selectedImage
            self.signUpSecondView.profileImageView.backgroundColor = selectedColor
            self.selectedProfileId = selectedIndex
        }
        present(profilePickerVC, animated: true)
    }
}

// MARK: - Agree Buttons Actions
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

// MARK: - SignUp Button Action
extension SignUpSecondViewController {
    @objc private func signUpButtonTapped() {
        let keychainManager = KeychainManager()
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "signupData",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]

        guard let jsonData = keychainManager.fetchItem(with: query) else {
            print("키체인에서 데이터를 불러오지 못했습니다.")
            return
        }

        do {
            var signUpData = try JSONDecoder().decode(SignUpData.self, from: jsonData)

            guard let nickname = signUpSecondView.nickNameTextField.text, !nickname.isEmpty,
                  let selectedProfileId = selectedProfileId else {
                print("닉네임이 비어있거나 프로필을 선택하지 않았습니다.")
                return
            }

            signUpData.secondSignupDto = SecondSignupDto(
                nickname: nickname,
                profileId: selectedProfileId,
                interests: signUpSecondView.selectedInterests.map(convertInterestToEnglish)
            )

            SignUpManager.shared.submitSignupData(signupData: signUpData) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        print("회원가입 성공")
                        let loginVC = LoginViewController()
                        self?.navigationController?.pushViewController(loginVC, animated: true)
                    case .failure(let error):
                        print("회원가입 실패: \(error.localizedDescription)")
                    }
                }
            }
        } catch {
            print("키체인 데이터 디코딩 실패: \(error)")
        }
    }

    private func convertInterestToEnglish(_ interest: String) -> String {
        let mapping: [String: String] = [
            "패션": "FASHION",
            "뷰티": "BEAUTY",
            "음식": "FOOD",
            "캐릭터": "CHARACTER",
            "드라마/영화": "MOVIES",
            "라이프 스타일": "LIFESTYLE",
            "예술": "ART",
            "IT": "IT",
            "스포츠": "SPORTS",
            "셀럽": "CELEBRITY",
            "반려동물": "PETS"
        ]
        return mapping[interest] ?? interest
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
