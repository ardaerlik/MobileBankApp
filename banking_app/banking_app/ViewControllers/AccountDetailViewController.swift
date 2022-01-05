//
//  AccountDetailViewController.swift
//  banking_app
//
//  Created by Arda Erlik on 12/8/21.
//

import UIKit

class AccountDetailViewController: UIViewController {

    @IBOutlet private weak var accountTypeImageView: UIImageView!
    @IBOutlet private weak var accountNumberLabel: UILabel!
    @IBOutlet private weak var usableAmountLabel: UILabel!
    
    var accountModel: AccountModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI(with: accountModel!)
    }
    
    private func setUI(with model: AccountModel) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        switch model.accountType {
        case .EUR:
            accountTypeImageView.image = UIImage(named: "EUR")
        case .TRY:
            accountTypeImageView.image = UIImage(named: "TRY")
        case .USD:
            accountTypeImageView.image = UIImage(named: "USD")
        case .XAU:
            accountTypeImageView.image = UIImage(named: "XAU")
        case .none:
            accountTypeImageView.image = UIImage(named: "TRY")
        }
        accountNumberLabel.text = model.accountNumber!.separate(every: 4, with: " ")
        usableAmountLabel.text = "Usable Amount: \(model.usableAmount!)"
    }
}
