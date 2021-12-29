//
//  InvestmentsViewController.swift
//  banking_app
//
//  Created by Arda Erlik on 12/7/21.
//

import UIKit

class InvestmentsViewController: BaseViewController {

    @IBOutlet private weak var investmentsTableView: UITableView!
    
    var investmentModel: [InvestmentModel]? {
        didSet {
            investmentsTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoadingView()
        getInvestments()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Investments"
    }
    
    func getInvestments() {
        NetworkManager.shared.getInvestmentsDetail { result in
            self.dismissLoadingView()
            switch result {
            case .success(let model):
                self.investmentModel = model
            case .failure(_):
                break
            }
        }
    }
}

extension InvestmentsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = InvestmentsTableViewCell()
        return cell
    }
}
