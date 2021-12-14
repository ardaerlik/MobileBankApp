//
//  AccountsDataSource.swift
//  banking_app
//
//  Created by Arda Erlik on 12/11/21.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

class AccountsDataSource {
    private var accountList: [Account] = []
    private var accountIdList: [String] = []
    var db: Firestore!
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
    }
    
    func getDataDeneme(tckn: String) {
        let userDocReference = db.collection("users").document("\(tckn)")

        userDocReference.getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                self.accountIdList = userData!["accounts"] as! [String]
                
                for i in 0...(self.accountIdList.count - 1) {
                    let accountDocReference = self.db.collection("accounts").document("\(self.accountIdList[i])")
                    
                    accountDocReference.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let accountData = document.data()
                            let account = Account(Amount: accountData!["Amount"] as! Int, Currency: accountData!["Currency"] as! String)
                            self.accountList.append(account)
                        }
                    }
                }
            } else {
                print("Data does not exist")
            }
        }
    }
    
//    func getData() {
//        let userDocReference = db.collection("users").document("\(tckn)")
//        userDocReference.getDocument { [self] (docSnapshot, error) in
//            let myData = docSnapshot!.data()
//            self.accountIdList = myData?["accounts"] as! [String]
//        }
//
//        print(accountIdList)
//
//        for i in 0...accountIdList.count {
//            let accountDocReference = Firestore.firestore().collection("accounts").document("\(accountIdList[i])")
//            accountDocReference.getDocument { [self] (docSnapshot, error) in
//                let myData = docSnapshot!.data()
//                self.accountList[i].Amount = myData?["Amount"] as! Int
//                self.accountList[i].Currency = myData?["Currency"] as! String
//            }
//        }
//
//        print(accountList)
//    }
    
    func getNumberOfAccounts() -> Int {
        return accountList.count
    }
    
    func getAccountForIndex(index: Int) -> Account {
        let realIndex = index % accountList.count
        return accountList[realIndex]
    }
    
}
