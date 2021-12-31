//
//  InvestmentsDetailTableViewCell.swift
//  banking_app
//
//  Created by Arda Erlik on 12/8/21.
//

import UIKit

class InvestmentsDetailTableViewCell: UITableViewCell {

    @IBOutlet private weak var investmentNameLabel: UILabel!
    @IBOutlet private weak var investmentChangeImageView: UIImageView!
    @IBOutlet private weak var investmentPriceLabel: UILabel!
    
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
    
    func configure(with model: InvestmentModel) {
        investmentNameLabel.text = model.name
        investmentPriceLabel.text = "\(model.price ?? 0) TRY"
        
        var imageName: String
        switch model.change {
        case .Down:
            imageName = "AsagiOk"
        case .Same:
            imageName = "YatayOk"
        case .Up:
            imageName = "YukariOk"
        default:
            imageName = "YatayOk"
        }
        
        investmentChangeImageView.image = UIImage(named: imageName)
    }

}
