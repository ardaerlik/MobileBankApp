//
//  MainViewController.swift
//  banking_app
//
//  Created by Arda Erlik on 12/7/21.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    
    var tckn: String = ""
    let accountsDataSource = AccountsDataSource()
    let cardsDataSource = CardsDataSource()
    
    @IBOutlet weak var accountsTableView: UITableView!
    @IBOutlet weak var cardsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("tckn in MainViewController: \(tckn)")
        
        accountsDataSource.delegate = self
        accountsDataSource.getDataDeneme(tckn: "yyapH8wvhm6XQjWv9Bzk")
        //cardsDataSource.getData()
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

extension MainViewController: AccountsDataSourceDelegate {
    func accountListLoaded() {
        accountsTableView.reloadData()
    }
    
    
}

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
