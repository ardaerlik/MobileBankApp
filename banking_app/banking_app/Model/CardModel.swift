//
//  Card.swift
//  banking_app
//
//  Created by Arda Erlik on 12/13/21.
//

import Foundation
import Firebase

struct CardModel {
    var cardType: CardType?
    var duePayment: String?
    var cardNumber: String?
    var usableLimit: Double?
    var currentDebt: Double?
    
    init(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary,
              let isVisa = dictionary["isVisa"] as? Bool,
              let duePayment = dictionary["duePayment"] as? Timestamp,
              let cardNumber = dictionary["cardNumber"] as? String,
              let usableLimit = dictionary["usableLimit"] as? Double,
              let currentDebt = dictionary["currentDebt"] as? Double else { return }
        self.cardType = isVisa == true ? .visa : .masterCard
        self.duePayment = duePayment.dateValue().toString()
        self.cardNumber = cardNumber.separate(every: 4, with: " ")
        self.usableLimit = usableLimit
        self.currentDebt = currentDebt
    }
}

enum CardType {
    case masterCard
    case visa
}
