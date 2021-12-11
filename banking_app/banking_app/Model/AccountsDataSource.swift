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
    
    init(tckn: String) {
        self.tckn = tckn
        let accountsCollReference = Firestore.firestore().collection("accounts")
        let userDocReference = Firestore.firestore().document("users/\(tckn)")
        userDocReference.getDocument { [self] (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
            let myData = docSnapshot.data()
            self.accountIdList = myData?["Accounts"] as? [String] ?? self.accountIdList
        }
        
    }
    
}
