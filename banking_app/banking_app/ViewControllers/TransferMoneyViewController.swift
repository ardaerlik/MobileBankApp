//
//  TransferMoneyViewController.swift
//  banking_app
//
//  Created by Arda Erlik on 12/28/21.
//

import UIKit

class TransferMoneyViewController: UIViewController {

    @IBOutlet private weak var senderAccountPickerView: UIPickerView!
    @IBOutlet private weak var receiverAccountIbanTextField: UITextField!
    @IBOutlet private weak var receiverTcknTextField: UITextField!
    @IBOutlet private weak var transferAmountTextField: UITextField!
    @IBOutlet private weak var amountErrorLabel: UILabel!
    @IBOutlet private weak var transferErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receiverTcknTextField.delegate = self
        receiverAccountIbanTextField.delegate = self
        transferAmountTextField.delegate = self
        senderAccountPickerView.delegate = self
        senderAccountPickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        amountErrorLabel.isHidden = true
        transferErrorLabel.isHidden = true
        amountErrorLabel.textColor = .black
        transferErrorLabel.textColor = .black
    }

    @IBAction func makeTransferButtonTouched(_ sender: UIButton) {
        let senderAccountIban: String = (AppSingleton.shared.userModel?.accounts[senderAccountPickerView.selectedRow(inComponent: 0)].accountNumber)!
        let receiverAccountIban: String = receiverAccountIbanTextField.text!
        let receiverTckn: String = receiverTcknTextField.text!
        let amount: Double = Double(transferAmountTextField.text!)!
        
        let transferDictionary: [String: Any] = ["receiverTCKN": receiverTckn, "receiverAccount": receiverAccountIban, "senderTCKN": AppSingleton.shared.userModel?.tckn ?? "", "senderAccount": senderAccountIban, "amount": amount]
        
        NetworkManager.shared.makeTransfer(with: TransactionModel(with: transferDictionary)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let transaction):
                self.transferErrorLabel.textColor = .green
                self.transferErrorLabel.text = "Transaction has made succesfully\nID: \(transaction.transferId ?? "")"
                self.transferErrorLabel.isHidden = false
                
                for var account in AppSingleton.shared.userModel!.accounts {
                    if account.accountNumber == transaction.senderAccount {
                        account.usableAmount! -= transaction.amount!
                        break
                    }
                }
            case .failure(let errorType):
                self.transferErrorLabel.textColor = .red
                self.transferErrorLabel.text = errorType.rawValue
                self.transferErrorLabel.isHidden = false
            }
        }
    }
}

extension TransferMoneyViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // TODO: text field
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: text field
    }
}

extension TransferMoneyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (AppSingleton.shared.userModel?.accounts.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(AppSingleton.shared.userModel?.accounts[row].accountType?.rawValue ?? "") \(AppSingleton.shared.userModel?.accounts[row].accountNumber!.separate(every: 4, with: " ") ?? "")"
    }
}
