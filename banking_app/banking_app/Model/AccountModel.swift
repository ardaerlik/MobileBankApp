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
        
    }
}

enum AccountType {
    case TRY
    case USD
    case EUR
    case XAU
}
