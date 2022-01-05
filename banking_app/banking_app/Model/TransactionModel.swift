//
//  TransactionModel.swift
//  banking_app
//
//  Created by Can Koz on 21.12.2021.
//

import Foundation

struct TransactionModel {
    var transferId: String?
    var receiverTCKN: String?
    var senderTCKN: String?
    var receiverAccount: String?
    var senderAccount: String?
    var amount: Double?
    
    init(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary,
              let receiverTCKN = dictionary["receiverTCKN"] as? String,
              let senderTCKN = dictionary["senderTCKN"] as? String,
              let amount = dictionary["amount"] as? Double else { return }
        
        self.receiverTCKN = receiverTCKN
        self.senderTCKN = senderTCKN
        self.amount = amount
    }
    
    init(outgoing dictionary: [String: Any]?) {
        guard let dictionary = dictionary,
              let receiverTCKN = dictionary["receiverTCKN"] as? String,
              let senderTCKN = dictionary["senderTCKN"] as? String,
              let amount = dictionary["amount"] as? Double,
              let receiverAccount = dictionary["receiverAccount"] as? String,
              let senderAccount = dictionary["senderAccount"] as? String else { return }
        
        self.receiverTCKN = receiverTCKN
        self.senderTCKN = senderTCKN
        self.amount = amount
        self.receiverAccount = receiverAccount
        self.senderAccount = senderAccount
    }
}
