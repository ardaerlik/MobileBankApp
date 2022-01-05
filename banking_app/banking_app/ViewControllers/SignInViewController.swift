//
//  ViewController.swift
//  banking_app
//
//  Created by Can Koz on 6.12.2021.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet private weak var tckn: UITextField!
    @IBOutlet private weak var password: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        errorLabel.isHidden = true
        errorLabel.textColor = .red
        tckn.delegate = self
        password.delegate = self
        tckn.tag = 1
        password.tag = 2
        setupToolbarForTextField()
        initializeHideKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signIn(_ sender: Any) {
        NetworkManager.shared.getUserData(with: LoginModel(tckn: tckn.text, password: password.text)) { [weak self] result in
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
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        let previousButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(previousTextField))
        previousButton.image = UIImage(systemName: "chevron.up")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        barForPassword.items = [previousButton, flexSpace, doneButton]
        barForPassword.sizeToFit()
        password.inputAccessoryView = barForPassword
        
        let barForTckn = UIToolbar()
        let nextButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(nextTextField))
        nextButton.image = UIImage(systemName: "chevron.down")
        barForTckn.items = [nextButton, flexSpace, flexSpace]
        barForTckn.sizeToFit()
        tckn.inputAccessoryView = barForTckn
    }
    
    private func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func previousTextField() {
        //password.resignFirstResponder()
        tckn.becomeFirstResponder()
    }
    
    @objc private func nextTextField() {
        //tckn.resignFirstResponder()
        password.becomeFirstResponder()
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
