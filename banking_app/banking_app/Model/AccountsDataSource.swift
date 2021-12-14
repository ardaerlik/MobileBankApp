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
    private var db: Firestore!
    var delegate: AccountsDataSourceDelegate?
    
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
                
                print("Deneme: \(self.accountList[0].Currency)  \(self.accountList[0].Amount)")
                self.delegate?.accountListLoaded()
            } else {
                print("Data does not exist")
            }
        }
    }
    
    func getNumberOfAccounts() -> Int {
        return accountList.count
    }
    
    func getAccountForIndex(index: Int) -> Account {
        let realIndex = index % accountList.count
        return accountList[realIndex]
    }
    
}
