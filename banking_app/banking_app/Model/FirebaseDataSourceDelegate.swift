//
//  AccountsDataSourceDelegate.swift
//  banking_app
//
//  Created by Arda Erlik on 12/14/21.
//

import Foundation

protocol FirebaseDataSourceDelegate {
    func accountListLoaded()
    func cardListLoaded()
}