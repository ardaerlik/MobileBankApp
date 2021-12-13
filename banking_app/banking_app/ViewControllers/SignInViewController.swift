//
//  ViewController.swift
//  banking_app
//
//  Created by Can Koz on 6.12.2021.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    var tcknValue: String = ""
    @IBOutlet weak var tckn: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var docRef: DocumentReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        docRef = Firestore.firestore().document("users/ji25LVcewBlWglUtnlGs")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backButton = UIBarButtonItem()
        backButton.title = "Log Out"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        let mainViewController = segue.destination as! MainViewController
        mainViewController.tckn = tcknValue
    }

    @IBAction func signIn(_ sender: Any) {
        tcknValue = tckn.text!
//        let tcknText = tckn.text
//        let passwordText = password.text
//        let  dataToSave: [String: Any] = ["tckn": tcknText, "password": passwordText]
//        docRef.setData(dataToSave) { (error) in
//            if let error = error {
//                print("error")
//            }
//        }
    }
    
}

