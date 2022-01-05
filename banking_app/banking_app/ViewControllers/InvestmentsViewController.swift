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
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! InvestmentsTableViewCell
        
        if let indexPath = investmentsTableView.indexPath(for: cell) {
            let investmentType: InvestmentCategory
            switch indexPath.row {
            case 0:
                investmentType = .Stock
            case 1:
                investmentType = .Forex
            case 2:
                investmentType = .Fund
            default:
                investmentType = .Stock
            }
            let investmentsDetailViewController = segue.destination as! InvestmentsDetailViewController
            
            investmentsDetailViewController.investments = InvestmentModel.getInvestmentsByCategory(with: investmentModel!, by: investmentType)
            investmentsDetailViewController.title = investmentType.rawValue
        }
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
        if investmentModel != nil {
            return 3
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvestmentTypeTableCell") as! InvestmentsTableViewCell
        
        if indexPath.row == 0 {
            cell.configure(with: InvestmentCategory.Stock.rawValue)
        } else if indexPath.row == 1 {
            cell.configure(with: InvestmentCategory.Forex.rawValue)
        } else if indexPath.row == 2 {
            cell.configure(with: InvestmentCategory.Fund.rawValue)
        }
        
        return cell
    }
}
