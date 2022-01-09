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
    @IBOutlet private weak var transferErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receiverTcknTextField.delegate = self
        receiverAccountIbanTextField.delegate = self
        transferAmountTextField.delegate = self
        senderAccountPickerView.delegate = self
        senderAccountPickerView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        receiverAccountIbanTextField.text = ""
        receiverTcknTextField.text = ""
        transferAmountTextField.text = ""
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        transferErrorLabel.isHidden = true
        transferErrorLabel.textColor = .black
        setupToolbarForTextField()
        initializeHideKeyboard()
    }

    @IBAction func makeTransferButtonTouched(_ sender: Any) {
        if receiverTcknTextField.text!.isEmpty || receiverAccountIbanTextField.text!.isEmpty || transferAmountTextField.text!.isEmpty {
            self.transferErrorLabel.textColor = .red
            self.transferErrorLabel.text = AppError.emptyInput.rawValue
            self.transferErrorLabel.isHidden = false
            return
        }
        
        let senderAccountIban: String = (AppSingleton.shared.userModel?.accounts[senderAccountPickerView.selectedRow(inComponent: 0)].accountNumber)!
        let receiverAccountIban: String = receiverAccountIbanTextField.text!
        let receiverTckn: String = receiverTcknTextField.text!
        let amount: Double = Double(transferAmountTextField.text!)!
        
        let transferDictionary: [String: Any] = ["receiverTCKN": receiverTckn, "receiverAccount": receiverAccountIban, "senderTCKN": AppSingleton.shared.userModel?.tckn ?? "", "senderAccount": senderAccountIban, "amount": amount]
        
        NetworkManager.shared.makeTransfer(with: TransactionModel(outgoing: transferDictionary)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let transactionId):
                self.transferErrorLabel.textColor = .green
                self.transferErrorLabel.text = "Transaction has made succesfully\nID: \(transactionId)"
                self.transferErrorLabel.isHidden = false
            case .failure(let errorType):
                self.transferErrorLabel.textColor = .red
                self.transferErrorLabel.text = errorType.rawValue
                self.transferErrorLabel.isHidden = false
            }
        }
    }
    
    private func setupToolbarForTextField() {
        let barForIban = UIToolbar()
        let barForTckn = UIToolbar()
        let barForAmount = UIToolbar()
        let nextButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(nextTextField))
        let previousButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(previousTextField))
        let doneButton = UIBarButtonItem(title: "Make Transfer", style: .plain, target: self, action: #selector(dismissKeyboardAndMakeTransfer))
        nextButton.image = UIImage(systemName: "chevron.down")
        previousButton.image = UIImage(systemName: "chevron.up")
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        barForIban.items = [nextButton, flexSpace, flexSpace]
        barForTckn.items = [nextButton, previousButton, flexSpace]
        barForAmount.items = [previousButton, flexSpace, doneButton]
        barForIban.sizeToFit()
        barForTckn.sizeToFit()
        barForAmount.sizeToFit()
        
        //receiverAccountIbanTextField.inputAccessoryView = barForIban
        //receiverTcknTextField.inputAccessoryView = barForTckn
        //transferAmountTextField.inputAccessoryView = barForAmount
    }
    
    private func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func dismissKeyboardAndMakeTransfer() {
        self.view.endEditing(true)
        makeTransferButtonTouched(self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc private func previousTextField() {
        
    }
    
    @objc private func nextTextField() {
        
    }
}

extension TransferMoneyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
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
