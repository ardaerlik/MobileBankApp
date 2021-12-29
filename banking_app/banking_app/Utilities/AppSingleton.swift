//
//  AppSingleton.swift
//  banking_app
//
//  Created by Can Koz on 18.12.2021.
//

import Foundation

final class AppSingleton {

    static let shared =  AppSingleton()
    
    private init() { }

    var userModel: UserModel? = nil
//    var investmentModels: [InvestmentModel]? = nil
//    var transactionModels: [TransactionModel]? = nil

}
