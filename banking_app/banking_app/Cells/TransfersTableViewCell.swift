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
        layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 15
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    func configure(with model: TransactionModel?) {
        transferAmountLabel.text = "\(model?.amount ?? 0)"
        transferIdLabel.text = model?.transferId
        
        if model?.senderTCKN == AppSingleton.shared.userModel?.tckn {
            userTcknLabel.text = model?.senderTCKN
            otherTcknLabel.text = model?.receiverTCKN
            transferWayImageView.image = UIImage(named: "SagaOk")
        } else {
            userTcknLabel.text = model?.receiverTCKN
            otherTcknLabel.text = model?.senderTCKN
            transferWayImageView.image = UIImage(named: "SolaOk")
        }
    }

}
