//
//  MainViewController.swift
//  banking_app
//
//  Created by Arda Erlik on 12/7/21.
//

import UIKit

class MainViewController: UIViewController {

    //@IBOutlet weak var backButton: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = "Log Out"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
