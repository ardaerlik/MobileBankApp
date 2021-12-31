//
//  InvestmentsTableViewCell.swift
//  banking_app
//
//  Created by Arda Erlik on 12/27/21.
//

import UIKit

class InvestmentsTableViewCell: UITableViewCell {

    @IBOutlet private weak var investmentTypeLabel: UILabel!
    
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
    
    func configure(with label: String) {
        investmentTypeLabel.text = label
    }

}
