//
//  SettingsViewController.swift
//  banking_app
//
//  Created by Arda Erlik on 12/7/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var tcknLabel: UILabel!
    @IBOutlet private weak var gsmLabel: UILabel!
    @IBOutlet private weak var addressTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        setUI(with: AppSingleton.shared.userModel!)
    }
    
    private func setUI(with model: UserModel) {
        userNameLabel.text = model.username
        tcknLabel.text = model.tckn
        gsmLabel.text = model.gsm
        addressTextView.text = model.address
        // TODO: Textview change input
    }
    
    @IBAction func changePasswordTouched(_ sender: UIButton) {
        // TODO: Add segue to ChangePasswordViewController
    }
}
