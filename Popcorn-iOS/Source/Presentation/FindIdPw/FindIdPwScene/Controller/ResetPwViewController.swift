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
        resetPwView.completeButton.addAction(UIAction { _ in
            self.completeButtonTapped()
        }, for: .touchUpInside)

        resetPwView.pwEyeButton.addAction(UIAction { _ in
            self.passwordEyeButtonTapped()
        }, for: .touchUpInside)

        resetPwView.checkPwEyeButton.addAction(UIAction { _ in
            self.checkPwEyeButtonTapped()
        }, for: .touchUpInside)
    }
    private func completeButtonTapped() {
        // TODO: 서버와 통신
        let completeResetPwViewController = CompleteResetPwViewController()
        self.navigationController?.pushViewController(completeResetPwViewController, animated: true)
    }

    private func passwordEyeButtonTapped() {
            resetPwView.pwTextField.isSecureTextEntry.toggle()
    }

    private func checkPwEyeButtonTapped() {
            resetPwView.checkPwTextField.isSecureTextEntry.toggle()
    }
}

// MARK: - TextField Delegate Protocol
extension ResetPwViewController: UITextFieldDelegate {
    private func setupTextField() {
        [
            resetPwView.pwTextField,
            resetPwView.checkPwTextField
        ].forEach {
            $0.delegate = self
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == resetPwView.pwTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray3)
        }
        if textField == resetPwView.checkPwTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray3)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == resetPwView.pwTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray4)
        }
        if textField == resetPwView.checkPwTextField {
            textField.backgroundColor = UIColor(resource: .popcornGray4)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == resetPwView.pwTextField {
            guard let pwText = resetPwView.pwTextField.text, !pwText.isEmpty else { return false }
            resetPwView.checkPwTextField.becomeFirstResponder()
            return true
        }
        if textField == resetPwView.checkPwTextField {
            guard let pwText = resetPwView.pwTextField.text, !pwText.isEmpty,
                  let checkPwText = resetPwView.checkPwTextField.text, !checkPwText.isEmpty else { return false }
            resetPwView.checkPwTextField.resignFirstResponder()
            resetPwView.completeButton.sendActions(for: .touchUpInside)
            return true
        }
       return false
    }
}
