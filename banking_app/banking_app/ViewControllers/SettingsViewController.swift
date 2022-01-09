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
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var occupationLabel: UILabel!
    @IBOutlet private weak var addressTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI(with: AppSingleton.shared.userModel!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setUI(with model: UserModel) {
        self.title = "Settings"
        avatarImageView.load(imageLocation: model.avatar)
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.link.cgColor
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        userNameLabel.text = model.username
        tcknLabel.text = model.tckn
        gsmLabel.text = model.gsm
        emailLabel.text = model.email
        occupationLabel.text = "\(model.occupation) - \(model.company)"
        addressTextView.text = model.address
        addressTextView.backgroundColor = .darkGray
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension UIImageView {
    func load(imageLocation: String) {
        DispatchQueue.global().async { [weak self] in
            let url = URL(string: imageLocation)
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
