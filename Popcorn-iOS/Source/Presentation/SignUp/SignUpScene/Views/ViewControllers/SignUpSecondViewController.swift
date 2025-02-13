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
    private let signUpSecondViewModel: SignUpSecondViewModelProtocol
    private let screenHeight = UIScreen.main.bounds.height
    private var selectedProfileId: Int?

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

    private func selectProfileImageButtonTapped() {
        signUpSecondViewModel.presentProfileImageView()
    }

    private func allAgreeButtonTapped() {
        signUpSecondViewModel.updateAllAgreeButtonState()
    }

    private func firstAgreeButtonTapped() {
        signUpSecondViewModel.updateFirstAgreeButtonState()
    }

    private func secondAgreeButtonTapped() {
        signUpSecondViewModel.updateSecondAgreeButtonState()
    }

    private func signUpButtonTapped() {
        signUpSecondViewModel.signUp()
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
