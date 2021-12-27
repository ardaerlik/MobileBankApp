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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        errorLabel.isHidden = true
        errorLabel.textColor = .red
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        NetworkManager.shared.changePassword(with: AppSingleton.shared.userModel!, oldPassword: oldPasswordTextField.text!, newPassword: newPasswordTextField.text!) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                AppSingleton.shared.userModel = user
            case .failure(let errorType):
                self.errorLabel.isHidden = false
                self.errorLabel.text = errorType.rawValue
            }
        }
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorLabel.isHidden = true
    }
}
