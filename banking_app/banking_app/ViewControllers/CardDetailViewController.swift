//
//  CardDetailViewController.swift
//  banking_app
//
//  Created by Arda Erlik on 12/8/21.
//

import UIKit

class CardDetailViewController: UIViewController {
    
    @IBOutlet private weak var cardTypeImageView: UIImageView!
    @IBOutlet private weak var cardNumberLabel: UILabel!
    @IBOutlet private weak var duePaymentLabel: UILabel!
    @IBOutlet private weak var currentDebtLabel: UILabel!
    
    var cardModel: CardModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI(with: cardModel!)
    }
    
    private func setUI(with model: CardModel) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        cardTypeImageView.image = model.cardType == .masterCard ? UIImage(named: "masterCard") : UIImage(named: "visaCard")
        cardNumberLabel.text = model.cardNumber
        duePaymentLabel.text = "Due of Payment: \(model.duePayment!)"
        currentDebtLabel.text = "Current Debt: \(model.currentDebt!.round(to: 2)) TL"
    }
}
