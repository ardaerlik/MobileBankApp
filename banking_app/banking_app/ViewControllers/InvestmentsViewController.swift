//
//  InvestmentsViewController.swift
//  banking_app
//
//  Created by Arda Erlik on 12/7/21.
//

import UIKit

class InvestmentsViewController: BaseViewController {

    @IBOutlet private weak var investmentsTableView: UITableView!
    
    var expandableInvestments: [ExpandableInvestments]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoadingView()
        getInvestments()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getInvestments() {
        NetworkManager.shared.getInvestmentsDetail { result in
            self.dismissLoadingView()
            switch result {
            case .success(let model):
                self.expandableInvestments = [ExpandableInvestments]()
                self.expandableInvestments!.append(ExpandableInvestments(isExpanded: true, investments: InvestmentModel.getInvestmentsByCategory(with: model, by: .Stock)))
                self.expandableInvestments!.append(ExpandableInvestments(isExpanded: true, investments: InvestmentModel.getInvestmentsByCategory(with: model, by: .Forex)))
                self.expandableInvestments!.append(ExpandableInvestments(isExpanded: true, investments: InvestmentModel.getInvestmentsByCategory(with: model, by: .Fund)))
                self.investmentsTableView.reloadData()
            case .failure(_):
                break
            }
        }
    }
    
}

extension InvestmentsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expandableInvestments != nil {
            if expandableInvestments![section].isExpanded {
                return expandableInvestments![section].investments.count
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvestmentsTableViewCell") as! InvestmentsTableViewCell
        cell.configure(with: expandableInvestments![indexPath.section].investments[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return InvestmentCategory.Stock.rawValue
        } else if section == 1 {
            return InvestmentCategory.Forex.rawValue
        } else if section == 2 {
            return InvestmentCategory.Fund.rawValue
        } else {
            return ""
        }
    }
    
}

extension InvestmentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let stackView = UIStackView()
        let label = UILabel()
        let image = UIImage(named: "AsagiOk")
        let imageView = UIImageView(image: image)
        label.text = "\(section)"
        stackView.addSubview(label)
        stackView.addSubview(imageView)
        
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.setTitle("Toggle", for: .normal)
        button.tag = section
        button.backgroundColor = .red
        stackView.addSubview(button)
        //return button
        return stackView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    @objc func handleExpandClose(button: UIButton) {
        if expandableInvestments == nil {
            return
        }
        
        let section = button.tag
        var indexPaths = [IndexPath]()
        for row in expandableInvestments![section].investments.indices{
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = expandableInvestments![section].isExpanded
        expandableInvestments![section].isExpanded = !isExpanded
        
        if isExpanded {
            investmentsTableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            investmentsTableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
}
