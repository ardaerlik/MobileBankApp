//
//  CardsCollectionViewCell.swift
//  banking_app
//
//  Created by Can Koz on 17.12.2021.
//

import UIKit

class CardsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var cardTypeImageView: UIImageView!
    @IBOutlet private weak var usableLimitLabel: UILabel!
    @IBOutlet private weak var cardNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
    }
    
    func configure(with model: CardModel?) {
        cardTypeImageView.image = model?.cardType == .masterCard ? UIImage(named: "masterCard") : UIImage(named: "visaCard")
        usableLimitLabel.text = "Usable Limit: \(model?.usableLimit?.round(to: 2) ?? 0 ) TL"
        cardNumberLabel.text = model?.cardNumber
    }
}
