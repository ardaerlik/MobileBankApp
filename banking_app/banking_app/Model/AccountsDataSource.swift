//
//  AccountsDataSource.swift
//  banking_app
//
//  Created by Arda Erlik on 12/11/21.
//

import Foundation
import Firebase

class AccountsDataSource {
    private var accountList: [Account] = []
    private var accountIdList: [String] = []
    private var tckn: String = ""
    
    init() {
    }
    
    func setTckn(tckn: String) {
        self.tckn = tckn
    }
    
    func getData() {
        let accountsCollReference = Firestore.firestore().collection("accounts")
        let userDocReference = Firestore.firestore().document("users/\(tckn)")
        userDocReference.getDocument { [self] (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
            let myData = docSnapshot.data()
            self.accountIdList = myData?["Accounts"] as? [String] ?? self.accountIdList
            
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
