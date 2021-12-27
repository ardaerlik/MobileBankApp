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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
