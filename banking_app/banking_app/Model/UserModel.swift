//
//  User.swift
//  banking_app
//
//  Created by Arda Erlik on 12/14/21.
//

import Foundation

struct UserModel {
    var accounts: [AccountModel]
    var cards: [CardModel]
    var worth: WorthModel
    var username: String
    var tckn: String
    var gsm: String
    var address: String
    var avatar: String
    var email: String
    var occupation: String
    var company: String
}
