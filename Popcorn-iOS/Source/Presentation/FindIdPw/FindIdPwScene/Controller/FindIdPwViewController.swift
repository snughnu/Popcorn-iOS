//
//  FindIdPwViewController.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 12/30/24.
//

import UIKit

class FindIdPwViewController: UIViewController {
    private let findIdPwView = FindIdPwView()
    private let screenHeight = UIScreen.main.bounds.height

    override func loadView() {
        view = findIdPwView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTextField()
        setupAddActions()
    }
}
// MARK: - Setup NavigationBar
extension FindIdPwViewController {
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
// MARK: - TextField Delegate Protocol
extension FindIdPwViewController: UITextFieldDelegate {
    private func setupTextField() {
        [
            findIdPwView.nameTextField,
            findIdPwView.emailTextField,
            findIdPwView.authNumberTextField
        ].forEach {
            $0.delegate = self
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == findIdPwView.nameTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray3)
        }
        if textField == findIdPwView.emailTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray3)
        }
        if textField == findIdPwView.authNumberTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray3)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == findIdPwView.nameTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray4)
        }
        if textField == findIdPwView.emailTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray4)
        }
        if textField == findIdPwView.authNumberTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray4)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == findIdPwView.nameTextField {
            guard let nameText = findIdPwView.nameTextField.text,
                  !nameText.isEmpty else { return false }
            findIdPwView.emailTextField.becomeFirstResponder()
            return true
        }
        if textField == findIdPwView.emailTextField {
            guard let idText = findIdPwView.emailTextField.text,
                  !idText.isEmpty else { return false }
            findIdPwView.authNumberTextField.becomeFirstResponder()
            return true
        }
        return false
    }
}

// MARK: - Setup AddActions
extension FindIdPwViewController {
    private func setupAddActions() {
        findIdPwView.duplicateCheckButton.addAction(UIAction { _ in
            self.duplicateCheckButtonTapped()
        }, for: .touchUpInside)

        findIdPwView.idButton.addAction(UIAction { _ in
            self.idButtonTapped()
        }, for: .touchUpInside)

        findIdPwView.pwButton.addAction(UIAction { _ in
            self.pwButtonTapped()
        }, for: .touchUpInside)
    }
}

// MARK: - selector 함수
extension FindIdPwViewController {
    @objc private func duplicateCheckButtonTapped() {
        // TODO: 서버와 통신
    }

    @objc private func idButtonTapped() {
        let findIdViewController = FindIdViewController()
        self.navigationController?.pushViewController(findIdViewController, animated: true)
    }

    @objc private func pwButtonTapped() {
//        let signUpSecondViewController = SignUpSecondViewController()
//        self.navigationController?.pushViewController(signUpSecondViewController, animated: true)
    }
}
