//
//  WalletViewController.swift
//  banking_app
//
//  Created by Arda Erlik on 12/7/21.
//

import UIKit
import Charts

class WalletViewController: UIViewController {
    
    @IBOutlet private weak var pieChartView: PieChartView!
    @IBOutlet private weak var netWorhLabel: UILabel!
    @IBOutlet private weak var totalWorthLabel: UILabel!
    @IBOutlet private weak var totalDebtLabel: UILabel!
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var fundsInfoLabel: UILabel!
    @IBOutlet private weak var fundsLabel: UILabel!
    @IBOutlet private weak var stocksInfoLabel: UILabel!
    @IBOutlet private weak var stocksLabel: UILabel!
    @IBOutlet private weak var bondsInfoLabel: UILabel!
    @IBOutlet private weak var bondsLabel: UILabel!
    
    var selectedEntityIndex: Int {
        get {
            segmentedControl.selectedSegmentIndex
        }
        set {
            DispatchQueue.main.async { [weak self]  in
                guard let self = self else { return }
                self.configureSegmentedArea(with: newValue == 0 ? .assets : .debts)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUIForInitialState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setUIForInitialState() {
        self.title = "Wallet"
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Assets", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Debts", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        
        fundsInfoLabel.text = "Funds"
        stocksInfoLabel.text = "Stocks"
        bondsInfoLabel.text = "Bonds"
        netWorhLabel.text = AppSingleton.shared.userModel?.worth.netWorth
        totalWorthLabel.text = AppSingleton.shared.userModel?.worth.totalWorth
        totalDebtLabel.text = AppSingleton.shared.userModel?.worth.totalDebt
        fundsLabel.text = "\(AppSingleton.shared.userModel?.worth.assets?.funds ?? 0) TL"
        stocksLabel.text = "\(AppSingleton.shared.userModel?.worth.assets?.stocks ?? 0) TL"
        bondsLabel.text = "\(AppSingleton.shared.userModel?.worth.assets?.bonds ?? 0) TL"
        bondsInfoLabel.isHidden = false
        bondsLabel.isHidden = false
        setPieChart()
    }
    
    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        selectedEntityIndex = sender.selectedSegmentIndex
    }
    
    private func configureSegmentedArea(with worth: WorthType) {
        switch worth {
        case .assets:
            setUIForInitialState()
        case .debts:
            setUIForDebts()
        }
    }
    
    private func setUIForDebts() {
        fundsInfoLabel.text = "Total Debts Amount"
        fundsLabel.text = AppSingleton.shared.userModel?.worth.debts?.totalDebtsAmount
        stocksInfoLabel.text = "Currency"
        stocksLabel.text = AppSingleton.shared.userModel?.worth.debts?.currency
        bondsInfoLabel.isHidden = true
        bondsLabel.isHidden = true
    }
    
    private func setPieChart() {
        pieChartView.isUserInteractionEnabled = false
        pieChartView.rotationEnabled = false
        pieChartView.drawHoleEnabled = false
        pieChartView.entryLabelFont = UIFont.boldSystemFont(ofSize: 14)
        pieChartView.legend.enabled = false
        
        guard let totalWorth = AppSingleton.shared.userModel?.worth.assets?.totalAsset,
              let fundWorth = AppSingleton.shared.userModel?.worth.assets?.funds,
              let stockWorth = AppSingleton.shared.userModel?.worth.assets?.stocks,
              let bondWorth = AppSingleton.shared.userModel?.worth.assets?.bonds else { return }
        
        let fundRatio = (fundWorth / totalWorth * 100).round(to: 2)
        let stockRatio = (stockWorth / totalWorth * 100).round(to: 2)
        let bondRatio = (bondWorth / totalWorth * 100).round(to: 2)
        
        var entries = [PieChartDataEntry]()
        entries.append(PieChartDataEntry(value: fundRatio, label: "Funds"))
        entries.append(PieChartDataEntry(value: stockRatio, label: "Stocks"))
        entries.append(PieChartDataEntry(value: bondRatio, label: "Bonds"))
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = [ UIColor.systemBlue, UIColor.systemGreen, UIColor.orange ]
        dataSet.drawValuesEnabled = false
        
        pieChartView.data = PieChartData(dataSet: dataSet)
    }
    
}
