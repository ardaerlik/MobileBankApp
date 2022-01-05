//
//  TransfersViewController.swift
//  banking_app
//
//  Created by Arda Erlik on 12/7/21.
//

import UIKit

class TransfersViewController: BaseViewController {

    @IBOutlet private weak var transfersTableView: UITableView!
    
    var transactionModel: [TransactionModel]? {
        didSet {
            transfersTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
        showLoadingView()
        getTransfers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func getTransfers() {
        NetworkManager.shared.getTransactionsDetail(with: AppSingleton.shared.userModel!) { result in
            self.dismissLoadingView()
            switch result {
            case .success(let model):
                self.transactionModel = model
            case .failure(_):
                break
            }
        }
    }
}

extension TransfersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TransfersTableViewCell = transfersTableView.dequeueReusableCell(withIdentifier: "TransfersTableViewCell") as! TransfersTableViewCell
        cell.configure(with: (transactionModel?[indexPath.row]))
        return cell
    }
}
