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
    }

    @IBAction func makeTransferButtonTouched(_ sender: UIButton) {
    }
}
