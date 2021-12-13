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
        let userDocReference = Firestore.firestore().collection("users").document("\(tckn)")
        userDocReference.getDocument { [self] (docSnapshot, error) in
            let myData = docSnapshot!.data()
            self.accountIdList = myData?["accounts"] as! [String]
        }
        
        print(accountIdList)
        
        for i in 0...accountIdList.count {
            let accountDocReference = Firestore.firestore().collection("accounts").document("\(accountIdList[i])")
            accountDocReference.getDocument { [self] (docSnapshot, error) in
                let myData = docSnapshot!.data()
                self.accountList[i].Amount = myData?["Amount"] as! Int
                self.accountList[i].Currency = myData?["Currency"] as! String
            }
        }
        
        print(accountList)
    }
    
    func getNumberOfAccounts() -> Int {
        return accountList.count
    }
    
    func getAccountForIndex(index: Int) -> Account {
        let realIndex = index % accountList.count
        return accountList[realIndex]
    }
    
}
