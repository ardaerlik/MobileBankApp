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
    
    func getTransactionsDetail(with model: UserModel, completion: @escaping (Result<[TransactionModel], AppError>) -> Void) {
        var transfers = [TransactionModel]()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        db.collection("transfers").whereField("receiverTCKN", isEqualTo: model.tckn).getDocuments { snapshot, error in
            if error != nil {
                completion(.failure(AppError.transfersError))
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    var transactionModel = TransactionModel(with: data)
                    transactionModel.transferId = document.documentID
                    transfers.append(transactionModel)
                }
            }
            dispatchGroup.wait()
        }
        
        db.collection("transfers").whereField("senderTCKN", isEqualTo: model.tckn).getDocuments { snapshot, error in
            if error != nil {
                completion(.failure(AppError.transfersError))
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    var transactionModel = TransactionModel(with: data)
                    transactionModel.transferId = document.documentID
                    transfers.append(transactionModel)
                }
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(transfers))
        }
    }
    
    func getInvestmentsDetail(completion: @escaping (Result<[InvestmentModel], AppError>) -> Void) {
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
    
    func changePassword(with model: UserModel, oldPassword: String, newPassword: String, completion: @escaping (Result<UserModel, AppError>) -> Void) {
        db.collection("users").document(model.tckn).getDocument { snapshot, error in
            if let data = snapshot?.data(),
               let oldPasswordDb = data["password"] as? String,
               (snapshot?.exists ?? false) && error == nil {
                if oldPasswordDb != oldPassword {
                    completion(.failure(AppError.invalidPassword))
                    return
                }
                
                if oldPassword == newPassword {
                    completion(.failure(AppError.samePassword))
                    return
                }
                
                self.db.collection("users").document(model.tckn).updateData(["password": newPassword]) { error2 in
                    if error2 != nil {
                        completion(.failure(AppError.databaseUpdateError))
                        return
                    }
                    
                    completion(.success(AppSingleton.shared.userModel!))
                }
            } else {
                completion(.failure(AppError.invalidCredentials))
            }
        }
    }
    
}
