//
//  Account.swift
//  banking_app
//
//  Created by Arda Erlik on 12/11/21.
//

import Foundation

struct AccountModel {
    var accountType: AccountType?
    var accountNumber: String?
    var usableAmount: Double?
    
    init(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary,
              let accountNumber = dictionary["accountNumber"] as? String,
              let usableAmount = dictionary["usableAmount"] as? Double,
              let accountTypeTmp = dictionary["accountType"] as? String else { return }
        self.accountNumber = accountNumber
        self.usableAmount = usableAmount
        
        switch accountTypeTmp {
        case "TRY":
            self.accountType = .TRY
        case "USD":
            self.accountType = .USD
        case "EUR":
            self.accountType = .EUR
        case "XAU":
            self.accountType = .XAU
        default:
            self.accountType = .TRY
        }
    }
}

enum AccountType {
    case TRY
    case USD
    case EUR
    case XAU
}
