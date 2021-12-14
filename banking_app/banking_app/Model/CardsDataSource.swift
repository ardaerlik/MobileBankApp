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
    private var db: Firestore!
    var delegate: FirebaseDataSourceDelegate?
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
    }
    
    func getData(tckn: String) {
        let userDocReference = db.collection("users").document("\(tckn)")
        
        userDocReference.getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                self.cardIdList = userData!["cards"] as! [String]
                
                for i in 0...(self.cardIdList.count - 1) {
                    let cardDocReference = self.db.collection("cards").document("\(self.cardIdList[i])")
                    
                    cardDocReference.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let cardData = document.data()
                            let card = Card(DuePay: cardData!["DuePay"] as! Timestamp, Issuer: cardData!["Issuer"] as! String, RLimit: cardData!["RLimit"] as! Int, TLimit:  cardData!["TLimit"] as! Int)
                            self.cardList.append(card)
                            
                            if (self.cardList.count == self.cardIdList.count) {
                                self.delegate?.cardListLoaded()
                            }
                        } else {
                            print("Data does not exist")
                        }
                    }
                }
            } else {
                print("Data does not exist")
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
