//
//  ChangePasswordViewController.swift
//  banking_app
//
//  Created by Arda Erlik on 12/27/21.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet private weak var oldPasswordTextField: UITextField!
    @IBOutlet private weak var newPasswordTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        errorLabel.isHidden = true
        errorLabel.textColor = .black
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        NetworkManager.shared.changePassword(with: AppSingleton.shared.userModel!, oldPassword: oldPasswordTextField.text!, newPassword: newPasswordTextField.text!) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let user):
                AppSingleton.shared.userModel = user
                self.errorLabel.textColor = .green
                self.errorLabel.text = "Password has been changed"
                self.errorLabel.isHidden = false
                self.navigationController?.popViewController(animated: true)
            case .failure(let errorType):
                self.errorLabel.textColor = .red
                self.errorLabel.text = errorType.rawValue
                self.errorLabel.isHidden = false
            }
        }
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorLabel.isHidden = true
    }
}
