//
//  TransfersViewController.swift
//  banking_app
//
//  Created by Arda Erlik on 12/7/21.
//

import UIKit

class TransfersViewController: UIViewController {

    @IBOutlet private weak var transfersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Transfers"
        setUI()
    }
    
    private func setUI() {
        self.title = "Transfers"
    }
}

extension TransfersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return AppSingleton.shared.transactionModels!.count
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: TransfersTableViewCell = transfersTableView.dequeueReusableCell(withIdentifier: "TransfersTableViewCell") as! TransfersTableViewCell
//        cell.configure(with: (AppSingleton.shared.transactionModels?[indexPath.row]))
//        return cell
        return UITableViewCell()
    }
}
