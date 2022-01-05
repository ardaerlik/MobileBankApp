//
//  ViewController.swift
//  banking_app
//
//  Created by Can Koz on 6.12.2021.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet private weak var tcknTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var signInButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tcknTextField.delegate = self
        passwordTextField.delegate = self
        tcknTextField.tag = 1
        passwordTextField.tag = 2
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        errorLabel.isHidden = true
        errorLabel.textColor = .red
        setupToolbarForTextField()
        initializeHideKeyboard()
    }
    
    @IBAction func signIn(_ sender: Any) {
        if passwordTextField.text!.isEmpty || tcknTextField.text!.isEmpty {
            self.errorLabel.isHidden = false
            self.errorLabel.text = AppError.emptyInput.rawValue
            return
        }
        
        NetworkManager.shared.getUserData(with: LoginModel(tckn: tcknTextField.text, password: passwordTextField.text)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                AppSingleton.shared.userModel = user
                self.performSegue(withIdentifier: "showTabbar", sender: nil)
            case .failure(let errorType):
                self.errorLabel.isHidden = false
                self.errorLabel.text = errorType.rawValue
            }
        }
    }
    
    private func setupToolbarForTextField() {
        let barForPassword = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Sign In", style: .plain, target: self, action: #selector(dismissKeyboardAndSign))
        let previousButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(previousTextField))
        previousButton.image = UIImage(systemName: "chevron.up")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        barForPassword.items = [previousButton, flexSpace, doneButton]
        barForPassword.sizeToFit()
        passwordTextField.inputAccessoryView = barForPassword
        
        let barForTckn = UIToolbar()
        let nextButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(nextTextField))
        nextButton.image = UIImage(systemName: "chevron.down")
        barForTckn.items = [nextButton, flexSpace, flexSpace]
        barForTckn.sizeToFit()
        tcknTextField.inputAccessoryView = barForTckn
    }
    
    private func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func dismissKeyboardAndSign() {
        self.view.endEditing(true)
        signIn(self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -=  (signInButton.frame.minY - (self.view.frame.height - keyboardSize.height))
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc private func previousTextField() {
        tcknTextField.becomeFirstResponder()
    }
    
    @objc private func nextTextField() {
        passwordTextField.becomeFirstResponder()
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorLabel.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
