//
//  TransfersTableViewCell.swift
//  banking_app
//
//  Created by Arda Erlik on 12/8/21.
//

import UIKit

class TransfersTableViewCell: UITableViewCell {

    @IBOutlet private weak var userTcknLabel: UILabel!
    @IBOutlet private weak var otherTcknLabel: UILabel!
    @IBOutlet private weak var transferAmountLabel: UILabel!
    @IBOutlet private weak var transferIdLabel: UILabel!
    @IBOutlet private weak var transferWayImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setUI(with model: TransactionModel) {
        // TODO: Change values of labels and image view
    }

}
