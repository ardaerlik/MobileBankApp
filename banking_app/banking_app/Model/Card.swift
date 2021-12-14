//
//  Card.swift
//  banking_app
//
//  Created by Arda Erlik on 12/13/21.
//

import Foundation
import Firebase

struct Card {
    var DuePay: Timestamp
    var Issuer: String
    var RLimit: Int
    var TLimit: Int
}
