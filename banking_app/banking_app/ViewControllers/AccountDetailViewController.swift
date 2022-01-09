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
        accountTypeImageView.image = UIImage(named: model.accountType!.rawValue)
        accountNumberLabel.text = model.accountNumber!.separate(every: 4, with: " ")
        usableAmountLabel.text = "\(model.usableAmount!.round(to: 2)) \(model.accountType!.rawValue)"
    }
}
