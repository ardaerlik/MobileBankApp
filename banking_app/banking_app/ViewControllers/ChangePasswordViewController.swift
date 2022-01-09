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
    @IBOutlet private weak var changePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        oldPasswordTextField.text = ""
        newPasswordTextField.text = ""
    }
    
    private func setUI() {
        self.title = "Change Password"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        errorLabel.isHidden = true
        errorLabel.textColor = .black
        setupToolbarForTextField()
        initializeHideKeyboard()
    }
    
    @IBAction func changePassword(_ sender: Any) {
        if oldPasswordTextField.text!.isEmpty || newPasswordTextField.text!.isEmpty {
            self.errorLabel.textColor = .red
            self.errorLabel.text = AppError.emptyInput.rawValue
            self.errorLabel.isHidden = false
            return
        }
        
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
    
    private func setupToolbarForTextField() {
        let barForOldPassword = UIToolbar()
        let barForNewPassword = UIToolbar()
        let nextButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(nextTextField))
        let previousButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(previousTextField))
        let doneButton = UIBarButtonItem(title: "Change Password", style: .plain, target: self, action: #selector(dismissKeyboardAndChangePassword))
        nextButton.image = UIImage(systemName: "chevron.down")
        previousButton.image = UIImage(systemName: "chevron.up")
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        barForOldPassword.items = [nextButton, flexSpace, flexSpace]
        barForNewPassword.items = [previousButton, flexSpace, doneButton]
        barForOldPassword.sizeToFit()
        barForNewPassword.sizeToFit()
        
        oldPasswordTextField.inputAccessoryView = barForOldPassword
        newPasswordTextField.inputAccessoryView = barForNewPassword
    }
    
    private func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func dismissKeyboardAndChangePassword() {
        self.view.endEditing(true)
        changePassword(self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (changePasswordButton.frame.maxY - (self.view.frame.height - keyboardSize.height) + 20)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc private func previousTextField() {
        oldPasswordTextField.becomeFirstResponder()
    }
    
    @objc private func nextTextField() {
        newPasswordTextField.becomeFirstResponder()
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorLabel.isHidden = true
    }
}
