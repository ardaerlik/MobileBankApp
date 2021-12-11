//
//  MainViewController.swift
//  banking_app
//
//  Created by Arda Erlik on 12/7/21.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    var collRefCards: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collRefCards = Firestore.firestore().collection("cards")
        print(collRefCards.document("Card1"))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
