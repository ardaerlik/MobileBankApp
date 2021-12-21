//
//  DateExtension.swift
//  banking_app
//
//  Created by Can Koz on 18.12.2021.
//

import Foundation

extension Date {

    func toString(format: String = "dd-MM-yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
