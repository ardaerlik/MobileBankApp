//
//  NetworkManager.swift
//  banking_app
//
//  Created by Can Koz on 16.12.2021.
//

import Foundation
import Firebase

class NetworkManager {
    static let shared = NetworkManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func getUserData(with model: LoginModel, completion: @escaping (Result<UserModel, AppError>) -> Void) {
        guard let tckn = model.tckn,
              let password = model.password else { return }
        
        var userCards = [CardModel]()
        var userAccounts = [AccountModel]()
        
        db.collection("users").document(tckn).getDocument { snapshot, error in
            
            if let data = snapshot?.data(),
               let cards = data["cards"] as? [[String: Any]],
               let accounts = data["accounts"] as? [[String: Any]],
               let worth = data["worth"] as? [String: Any],
               (snapshot?.exists ?? false) && error == nil {
                let isPasswordCorrect = password == (data["password"] as? String)
                
                cards.forEach { userCards.append(CardModel(with: $0)) } 
                accounts.forEach { userAccounts.append(AccountModel(with: $0)) }
                let worthModel = WorthModel(with: worth)
                completion(isPasswordCorrect ? .success(UserModel(accounts: userAccounts, cards: userCards, worth: worthModel)) : .failure(AppError.invalidPassword))
            } else {
                completion(.failure(AppError.invalidCredentials))
            }
        }
    }
    
    func getTransactionsDetail(with model: AccountModel, completion: @escaping (Result<TransactionModel, AppError>) -> Void) {
        
    }
    
    func getForexDetail(with model: ForexModel, completion: @escaping (Result<ForexModel, AppError>) -> Void) {
        
    }
    
    func getFundDetail(with model: FundModel, completion: @escaping (Result<FundModel, AppError>) -> Void) {
        
    }
    
    func getStockDetail(with model: StockModel, completion: @escaping (Result<StockModel, AppError>) -> Void) {
        
    }
    
}
