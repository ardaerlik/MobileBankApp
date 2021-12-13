//
//  CardsDataSource.swift
//  banking_app
//
//  Created by Arda Erlik on 12/13/21.
//

import Foundation
import Firebase

class CardsDataSource {
    private var cardList: [Account] = []
    private var cardIdList: [String] = []
    private var tckn: String = ""
    
    init() {
    }
    
    func setTckn(tckn: String) {
        self.tckn = tckn
    }
    
    func getData() {
        let cardsCollReference = Firestore.firestore().collection("cards")
        let userDocReference = Firestore.firestore().document("users/\(tckn)")
        userDocReference.getDocument { [self] (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
            let myData = docSnapshot.data()
            self.cardIdList = myData?["Cards"] as? [String] ?? self.cardIdList
            
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
