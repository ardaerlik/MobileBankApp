//
//  InvestmentsDetailViewController.swift
//  banking_app
//
//  Created by Arda Erlik on 12/8/21.
//

import UIKit

class InvestmentsDetailViewController: UIViewController {
    
    @IBOutlet private weak var investmentsDetailTableView: UITableView!
    
    var investments: [InvestmentModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        investmentsDetailTableView.reloadData()
    }

}

extension InvestmentsDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return investments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvestmentsDetailTableViewCell") as! InvestmentsDetailTableViewCell
        cell.configure(with: investments![indexPath.row])
        
        return cell
    }
}
