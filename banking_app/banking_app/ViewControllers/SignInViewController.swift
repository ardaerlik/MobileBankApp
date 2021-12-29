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
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorLabel.isHidden = true
    }
}
