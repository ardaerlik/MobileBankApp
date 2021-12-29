//
//  MainTabBarController.swift
//  banking_app
//
//  Created by Can Koz on 28.12.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
    }
}
