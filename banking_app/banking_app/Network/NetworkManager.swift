//
//  NetworkManager.swift
//  banking_app
//
//  Created by Can Koz on 16.12.2021.
//

import Foundation
import Firebase
import UIKit

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
//                    transactionModel.receiverTCKN = data["receiverTCKN"] as? String
//                    transactionModel.senderTCKN = data["senderTCKN"] as? String
//                    transactionModel.amount = data["amount"] as? Double
                    transactionModel.transferId = document.documentID
                    transfers.append(transactionModel)
                }
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        db.collection("transfers").whereField("senderTCKN", isEqualTo: model.tckn).getDocuments { snapshot, error in
            if error != nil {
                completion(.failure(AppError.transfersError))
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    var transactionModel = TransactionModel(with: data)
//                    transactionModel.receiverTCKN = data["receiverTCKN"] as? String
//                    transactionModel.senderTCKN = data["senderTCKN"] as? String
//                    transactionModel.amount = data["amount"] as? Double
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
    
//    func getUsersJSON(completion: @escaping (Result<[UserNetwork], AppError>) -> Void) {
//        let urlSession = URLSession(configuration: .default)
//        if let url = URL(string: "https://ardaerlik.me/mobilebankapp/users") {
//            var urlRequest = URLRequest(url: url)
//            urlRequest.httpMethod = "GET"
//            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
//                if let data = data {
//                    let decoder = JSONDecoder()
//                    let userArrayFromJSON = try! decoder.decode([UserNetwork].self, from: data)
//                    DispatchQueue.main.async {
//                        completion(.success(userArrayFromJSON))
//                    }
//                }
//            }
//            dataTask.resume()
//        }
//    }
//
//    func getAccountsJSON(completion: @escaping (Result<[AccountNetwork], AppError>) -> Void) {
//        let urlSession = URLSession(configuration: .default)
//        if let url = URL(string: "https://ardaerlik.me/mobilebankapp/accounts") {
//            var urlRequest = URLRequest(url: url)
//            urlRequest.httpMethod = "GET"
//            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
//                if let data = data {
//                    let decoder = JSONDecoder()
//                    let accountArrayFromJSON = try! decoder.decode([AccountNetwork].self, from: data)
//                    DispatchQueue.main.async {
//                        completion(.success(accountArrayFromJSON))
//                    }
//                }
//            }
//            dataTask.resume()
//        }
//    }
//
//    func getCardsJSON(completion: @escaping (Result<[CardNetwork], AppError>) -> Void) {
//        let urlSession = URLSession(configuration: .default)
//        if let url = URL(string: "https://ardaerlik.me/mobilebankapp/cards") {
//            var urlRequest = URLRequest(url: url)
//            urlRequest.httpMethod = "GET"
//            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
//                if let data = data {
//                    let decoder = JSONDecoder()
//                    let cardArrayFromJSON = try! decoder.decode([CardNetwork].self, from: data)
//                    DispatchQueue.main.async {
//                        completion(.success(cardArrayFromJSON))
//                    }
//                }
//            }
//            dataTask.resume()
//        }
//    }
//
//    func getWorthsJSON(completion: @escaping (Result<[WorthNetwork], AppError>) -> Void) {
//        let urlSession = URLSession(configuration: .default)
//        if let url = URL(string: "https://ardaerlik.me/mobilebankapp/worth") {
//            var urlRequest = URLRequest(url: url)
//            urlRequest.httpMethod = "GET"
//            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
//                if let data = data {
//                    let decoder = JSONDecoder()
//                    let worthArrayFromJSON = try! decoder.decode([WorthNetwork].self, from: data)
//                    DispatchQueue.main.async {
//                        completion(.success(worthArrayFromJSON))
//                    }
//                }
//            }
//            dataTask.resume()
//        }
//    }
//
//    func updateDatabase(users: [UserNetwork], accounts: [AccountNetwork], cards: [CardNetwork], worths: [WorthNetwork]) {
//        var accountsTmp = accounts
//        var cardsTmp = cards
//        var i = 0
//        for user in users {
//            if i > 120 {
//                break
//            }
//            var selectedAccounts = [[String: Any]]()
//            var selectedCards = [[String: Any]]()
//            for _ in 0...6 {
//                let tmp1 = accountsTmp.popLast()
//                selectedAccounts.append(["accountNumber": tmp1?.accountNumber,
//                                         "accountType": tmp1?.accountType,
//                                         "usableAmount": tmp1?.usableAmount])
//
//                let tmp2 = cardsTmp.popLast()
//                selectedCards.append(["cardNumber": tmp2?.cardNumber,
//                                      "currentDebt": tmp2?.currentDebt,
//                                      "duePayment": Timestamp(),
//                                      "isVisa": tmp2?.isVisa,
//                                      "usableLimit": tmp2?.usableLimit])
//            }
//
//            db.collection("users").document(user.tckn).setData([
//                "Address": user.Address,
//                "GSM": user.GSM,
//                "NameSurname": user.NameSurname,
//                "password": user.password,
//                "avatar": user.Avatar,
//                "email": user.Email,
//                "occupation": user.Occupation,
//                "company": user.Workplace,
//                "worth": ["assets": ["bonds": worths[i].bonds,
//                                     "funds": worths[i].funds,
//                                     "stocks": worths[i].stocks],
//                          "debts": ["currency": "TRY",
//                                    "totalDebtsAmount": worths[i].totalDebtsAmount],
//                          "netWorth": worths[i].netWorth,
//                          "totalDebt": worths[i].totalDebt,
//                          "totalWorth": worths[i].totalWorth],
//                "accounts": selectedAccounts,
//                "cards": selectedCards
//            ]) { err in
//                if let err = err {
//                    print("\(err)      \(i)")
//                }
//            }
//            i += 1
//        }
//    }
//
//    func deleteFiles() {
//        db.collection("users").getDocuments { snapshot, error in
//            if (snapshot?.documents) != nil {
//                for document in snapshot!.documents {
//                    if document.documentID == "potato" {
//                        continue
//                    }
//                    if let a = (document.data()["accounts"] as? [[String: Any?]])?[6]["accountNumber"],
//                       let b = (document.data()["cards"] as? [[String: Any?]])?[6]["cardNumber"] {
//                        self.db.collection("users").document(document.documentID).delete()
//                        print("DELETED \(document.documentID)")
//                    }
//                }
//                print("\(snapshot?.count)")
//            }
//        }
//    }
//
//    func updateTransfer() {
//        db.collection("users").getDocuments { snapshot, error in
//            if (snapshot?.documents) != nil {
//                var documentIds = [String]()
//                for document in snapshot!.documents {
//                    documentIds.append(document.documentID)
//                }
//
//                var transfers = [TransferNetwork]()
//                for i in 0...1000 {
//                    var randomInt1 = Int.random(in: 0..<documentIds.count)
//                    var randomInt2 = Int.random(in: 0..<documentIds.count)
//                    let randomAmount = Double.random(in: 0.0...20000.0)
//                    if randomInt1 == randomInt2 {
//                        randomInt2 = Int.random(in: 0..<documentIds.count)
//                        transfers.append(TransferNetwork(receiver: documentIds[randomInt1], sender: documentIds[randomInt2], amount: randomAmount))
//                    } else {
//                        transfers.append(TransferNetwork(receiver: documentIds[randomInt1], sender: documentIds[randomInt2], amount: randomAmount))
//                    }
//                }
//
//                for transfer in transfers {
//                    self.db.collection("transfers").addDocument(data: ["amount": transfer.amount,
//                                                                  "receiverTCKN": transfer.receiver,
//                                                                  "senderTCKN": transfer.sender])
//                }
//            }
//        }
//    }
//
//    func deleteTransfers() {
//        db.collection("transfers").getDocuments { snapshot, error in
//            if let data = snapshot?.documents {
//                print("\(snapshot!.count)")
//            }
//        }
//    }
    
    func makeTransfer(with model: TransactionModel, completion: @escaping (Result<TransactionModel, TransferError>) -> Void) {
        // MARK: TODO (Make Transfer)
        for account in AppSingleton.shared.userModel!.accounts {
            if account.accountNumber == model.senderAccount {
                if model.amount! > account.usableAmount! {
                    completion(.failure(TransferError.insufficientBalance))
                    return
                } else {
                    break
                }
            }
        }
        
        db.collection("users").document(model.receiverTCKN!).getDocument { snapshot, error in
            if !(snapshot?.exists ?? false) {
                completion(.failure(TransferError.invalidTckn))
                return
            }

            if let data = snapshot?.data(),
               let accounts = data["accounts"] as? [[String: Any]] {
                var receiverAccounts = [AccountModel]()
                
                accounts.forEach { receiverAccounts.append(AccountModel(with: $0))}
                
                var receiverExists = false
                for var receiver in receiverAccounts {
                    if receiver.accountNumber == model.receiverAccount {
                        // TODO: Account type kontrol et
                        receiver.usableAmount! += model.amount!
                        receiverExists = true
                        break
                    }
                }
                
                if !receiverExists {
                    completion(.failure(TransferError.invalidIban))
                    return
                }
                
                self.db.collection("users").document(model.receiverTCKN!).updateData(["accounts": receiverAccounts]) { error2 in
                    if error2 != nil {
                        completion(.failure(TransferError.databaseError))
                        return
                    }
                    
//                    self.db.collection("users").document(model.senderTCKN!).updateData(<#T##fields: [AnyHashable : Any]##[AnyHashable : Any]#>) { error3 in
//
//                    }
                }
            } else {
                completion(.failure(TransferError.databaseError))
            }
        }
    }
    
}

//struct StockNetwork: Decodable {
//    var change: String
//    var price: Double
//    var name: String
//}
//
//struct UserNetwork: Decodable {
//    var street: String
//    var city: String
//    var country: String
//    var Address: String
//    var Avatar: String
//    var GSM: String
//    var NameSurname: String
//    var Email: String
//    var password: String
//    var Occupation: String
//    var Workplace: String
//    var tckn: String
//}
//
//struct AccountNetwork: Decodable {
//    var accountNumber: String
//    var accountType: String
//    var usableAmount: Double
//}
//
//struct CardNetwork: Decodable {
//    var cardNumber: String
//    var currentDebt: Double
//    var isVisa: Bool
//    var usableLimit: Double
//}
//
//struct WorthNetwork: Decodable {
//    var bonds: Double
//    var funds: Double
//    var stocks: Double
//    var totalDebtsAmount: Double
//    var totalWorth: Double
//    var totalDebt: Double
//    var netWorth: Double
//}
//
//struct TransferNetwork {
//    var receiver: String
//    var sender: String
//    var amount: Double
//}

