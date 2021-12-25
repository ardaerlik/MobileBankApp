//
//  MainViewController.swift
//  banking_app
//
//  Created by Arda Erlik on 12/7/21.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    
    @IBOutlet private weak var cardsCollectionView: UICollectionView!
    @IBOutlet private weak var accountsCollectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutDidTapped))
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @objc func signOutDidTapped () {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCardDetail" {
            guard let object = sender as? CardModel else { return }
            let detailViewController = segue.destination as! CardDetailViewController
            detailViewController.cardModel = object
        } else if segue.identifier == "showAccountDetail" {
            guard let object = sender as? AccountModel else { return }
            let detailViewController = segue.destination as! AccountDetailViewController
            detailViewController.accountModel = object
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (accountsCollectionView == collectionView) {
            return AppSingleton.shared.userModel?.accounts.count ?? 0
        } else if (cardsCollectionView == collectionView) {
            return AppSingleton.shared.userModel?.cards.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (accountsCollectionView == collectionView) {
            let cell: AccountsCollectionViewCell = accountsCollectionView.dequeueReusableCell(withReuseIdentifier: "AccountsCollectionViewCell", for: indexPath) as! AccountsCollectionViewCell
            cell.configure(with: AppSingleton.shared.userModel?.accounts[indexPath.row])
            return cell
        } else if (cardsCollectionView == collectionView) {
            let cell: CardsCollectionViewCell = cardsCollectionView.dequeueReusableCell(withReuseIdentifier: "CardsCollectionViewCell", for: indexPath) as! CardsCollectionViewCell
            cell.configure(with: AppSingleton.shared.userModel?.cards[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (accountsCollectionView == collectionView) {
            self.performSegue(withIdentifier: "showAccountDetail", sender: AppSingleton.shared.userModel?.accounts[indexPath.row])
        } else if (cardsCollectionView == collectionView) {
            self.performSegue(withIdentifier: "showCardDetail", sender: AppSingleton.shared.userModel?.cards[indexPath.row])
        }
    }
    
}
