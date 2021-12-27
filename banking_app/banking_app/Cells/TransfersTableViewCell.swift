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
    
    func configure(with model: TransactionModel?) {
        transferAmountLabel.text = "\(model.amount!)"
        transferIdLabel.text = model.transferId
        
        if model.senderTCKN == AppSingleton.shared.userModel?.tckn {
            userTcknLabel.text = model.senderTCKN
            otherTcknLabel.text = model.receiverTCKN
            transferWayImageView.image = UIImage(named: "SagaOk")
        } else {
            userTcknLabel.text = model.receiverTCKN
            otherTcknLabel.text = model.senderTCKN
            transferWayImageView.image = UIImage(named: "SolaOk")
        }
    }

}
