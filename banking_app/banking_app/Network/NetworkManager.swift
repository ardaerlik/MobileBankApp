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
        var userAccounts = [AccountModel]() //TO DO
        
        db.collection("users").document(tckn).getDocument { snapshot, error in
            
            if let data = snapshot?.data(),
               let cards = data["cards"] as? [[String: Any]],
               (snapshot?.exists ?? false) && error == nil {
                let isPasswordCorrect = password == (data["password"] as? String)
                
                cards.forEach { userCards.append(CardModel(with: $0)) }
                
                completion(isPasswordCorrect ? .success(UserModel(accounts: userAccounts, cards: userCards)) : .failure(AppError.invalidPassword))
            } else {
                completion(.failure(AppError.invalidCredentials))
            }
        }
    }
    
    func getTransactionsDetail(with model: AccountModel, completion: @escaping (Result<TransactionModel, AppError>) -> Void) {
        
    }
    
}
