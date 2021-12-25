//
//  WorthModel.swift
//  banking_app
//
//  Created by Can Koz on 21.12.2021.
//

import Foundation

enum WorthType {
    case assets
    case debts
}

struct WorthModel {
    var assets: Asset?
    var debts: Debt?
    var netWorth: String?
    var totalDebt: String?
    var totalWorth: String?
    
    init(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary,
              let assetDictionary = dictionary["assets"] as? [String: Any]?,
            let debtDictionary = dictionary["debts"] as? [String: Any]?,
            let netWorth = dictionary["netWorth"] as? Double,
            let totalDebt = dictionary["totalDebt"] as? Double,
            let totalWorth = dictionary["totalWorth"] as? Double else { return }
        self.assets = Asset(with: assetDictionary)
        self.debts = Debt(with: debtDictionary)
        self.netWorth = "\(netWorth) TL"
        self.totalDebt = "- \(totalDebt) TL"
        self.totalWorth = "\(totalWorth) TL"
    }
}

struct Asset {
    var totalAsset: Double?
    var bonds: Double?
    var stocks: Double?
    var funds: Double?
    
    init(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary,
              let bonds = dictionary["bonds"] as? Double,
              let stocks = dictionary["stocks"] as? Double,
              let funds = dictionary["funds"] as? Double else { return }
        self.bonds = bonds
        self.stocks = stocks
        self.funds = funds
        self.totalAsset = bonds + funds + stocks
    }
}

struct Debt {
    var totalDebtsAmount: String?
    var currency: String?
    
    init(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary,
              let totalDebtsAmount = dictionary["totalDebtsAmount"] as? Double,
              let currency = dictionary["currency"] as? String else { return }
        self.totalDebtsAmount = "\(totalDebtsAmount) TL"
        self.currency = currency
    }
    
}
