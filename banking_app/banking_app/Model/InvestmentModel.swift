//
//  InvestmentModel.swift
//  banking_app
//
//  Created by Arda Erlik on 12/26/21.
//

import Foundation

struct InvestmentModel {
    var investmentCategory: InvestmentCategory?
    var change: Change?
    var price: Double?
    var name: String?
    
    init(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary,
              let price = dictionary["price"] as? Double,
              let investmentCategoryTmp = dictionary["category"] as? String,
              let changeTmp = dictionary["change"] as? String else { return }
        self.price = price
        
        switch investmentCategoryTmp {
        case "Stock":
            self.investmentCategory = .Stock
        case "Forex":
            self.investmentCategory = .Forex
        case "Fund":
            self.investmentCategory = .Fund
        default:
            self.investmentCategory = .none
        }
        
        switch changeTmp {
        case "Up":
            self.change = .Up
        case "Down":
            self.change = .Down
        case "NoChange":
            self.change = .Same
        default:
            self.change = .Same
        }
    }
    
    static func getInvestmentsByCategory(with investments: [InvestmentModel], by category: InvestmentCategory) -> [InvestmentModel] {
        var selectedInvestments = [InvestmentModel]()
        for investment in investments {
            if investment.investmentCategory == category {
                selectedInvestments.append(investment)
            }
        }
        return selectedInvestments
    }
    
}

enum InvestmentCategory: String {
    case Stock = "Stock"
    case Forex = "Forex"
    case Fund = "Fund"
}

enum Change {
    case Up
    case Down
    case Same
}
