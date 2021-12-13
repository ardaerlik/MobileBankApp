//
//  CardsDataSource.swift
//  banking_app
//
//  Created by Arda Erlik on 12/13/21.
//

import Foundation
import Firebase

class CardsDataSource {
    private var cardList: [Card] = []
    private var cardIdList: [String] = []
    private var tckn: String = ""
    
    init() {
    }
    
    func setTckn(tckn: String) {
        self.tckn = tckn
    }
    
    func getData() {
        let userDocReference = Firestore.firestore().document("users/\(tckn)")
        userDocReference.getDocument { [self] (docSnapshot, error) in
            let myData = docSnapshot!.data()
            self.cardIdList = myData?["Cards"] as? [String] ?? self.cardIdList
            
        }
        
        for i in 0...cardIdList.count {
            let accountDocReference = Firestore.firestore().document("accounts/\(cardIdList[i])")
            accountDocReference.getDocument { [self] (docSnapshot, error) in
                let myData = docSnapshot!.data()
                self.cardList[i].Issuer = myData?["Issuer"] as! String
                self.cardList[i].RLimit = myData?["RLimit"] as! Int
                self.cardList[i].TLimit = myData?["TLimit"] as! Int
                // "Date"???
            }
        }
    }
    
    func getNumberOfCards() -> Int {
        return cardList.count
    }
    
    func getCardForIndex(index: Int) -> Card {
        let realIndex = index % cardList.count
        return cardList[realIndex]
    }
    
}
