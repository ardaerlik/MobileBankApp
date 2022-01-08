//
//  AccountsCollectionViewCell.swift
//  banking_app
//
//  Created by Arda Erlik on 12/22/21.
//

import UIKit

class AccountsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var accountTypeImageView: UIImageView!
    @IBOutlet private weak var usableAmountLabel: UILabel!
    @IBOutlet private weak var accountNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
    }
    
    func configure(with model: AccountModel?) {
        accountTypeImageView.image = UIImage(named: model!.accountType!.rawValue)
        usableAmountLabel.text = "Usable Amount: \(model?.usableAmount?.round(to: 2) ?? 0) \(model?.accountType?.rawValue ?? "TRY")"
        accountNumberLabel.text = model?.accountNumber!.separate(every: 4, with: " ")
    }
}
