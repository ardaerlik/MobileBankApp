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
        // TODO: accountTypeImageView
        accountNumberLabel.text = model.accountNumber
        usableAmountLabel.text = "Usable Amount: \(model.usableAmount!)"
    }
}
