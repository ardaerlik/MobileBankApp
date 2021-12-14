//
//  MainViewController.swift
//  banking_app
//
//  Created by Arda Erlik on 12/7/21.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    let accountsDataSource = AccountsDataSource()
    let cardsDataSource = CardsDataSource()
    var tckn: String = ""
    
    @IBOutlet weak var accountsTableView: UITableView!
    @IBOutlet weak var cardsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("tckn in MainViewController: \(tckn)")
        
        accountsDataSource.delegate = self
        cardsDataSource.delegate = self
        accountsDataSource.getData(tckn: "yyapH8wvhm6XQjWv9Bzk")
        cardsDataSource.getData(tckn: "yyapH8wvhm6XQjWv9Bzk")
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

extension MainViewController: FirebaseDataSourceDelegate {
    func cardListLoaded() {
        cardsTableView.reloadData()
    }
    
    func accountListLoaded() {
        accountsTableView.reloadData()
    }
    
    
}

// MARK: burasi degisecek (TV -> CV)
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.accountsTableView == tableView) {
            return accountsDataSource.getNumberOfAccounts()
        } else {
            return cardsDataSource.getNumberOfCards()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.accountsTableView == tableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell") as! AccountsTableViewCell
            let account = accountsDataSource.getAccountForIndex(index: indexPath.row)
            
            cell.amountLabel.text = "\(account.Amount)"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell") as! CardsTableViewCell
            let card = cardsDataSource.getCardForIndex(index: indexPath.row)
            
            cell.rLimitLabel.text = "\(card.RLimit)"
            
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
}
