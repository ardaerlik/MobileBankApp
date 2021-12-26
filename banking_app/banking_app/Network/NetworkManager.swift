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
               let tckn = snapshot?.documentID,
               let username = data["NameSurname"] as? String,
               let address = data["Address"] as? String,
               let gsm = data["GSM"] as? String,
               let cards = data["cards"] as? [[String: Any]],
               let accounts = data["accounts"] as? [[String: Any]],
               let worth = data["worth"] as? [String: Any],
               (snapshot?.exists ?? false) && error == nil {
                let isPasswordCorrect = password == (data["password"] as? String)
                
                cards.forEach { userCards.append(CardModel(with: $0)) } 
                accounts.forEach { userAccounts.append(AccountModel(with: $0)) }
                let worthModel = WorthModel(with: worth)
                completion(isPasswordCorrect ? .success(UserModel(accounts: userAccounts, cards: userCards, worth: worthModel, username: username, tckn: tckn, gsm: gsm, address: address)) : .failure(AppError.invalidPassword))
            } else {
                completion(.failure(AppError.invalidCredentials))
            }
        }
    }
    
    func getTransactionsDetail(with model: AccountModel, completion: @escaping (Result<TransactionModel, AppError>) -> Void) {
        
    }
    
    func getInvestmentsDetail(with model: InvestmentModel, completion: @escaping (Result<[InvestmentModel], AppError>) -> Void) {
        db.collection("investments").getDocuments { snapshot, error in
            if error != nil {
                completion(.failure(AppError.investmentsError))
            } else {
                var investments = [InvestmentModel]()
                
                for document in snapshot!.documents {
                    let data = document.data()
                    var investmentModel = InvestmentModel(with: data)
                    investmentModel.name = document.documentID
                    investments.append(investmentModel)
                }
                
                completion(.success(investments))
            }
        }
    }
    
}
