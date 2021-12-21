//
//  StringExtension.swift
//  banking_app
//
//  Created by Can Koz on 18.12.2021.
//

import Foundation

extension String {
    func separate(every: Int, with separator: String) -> String {
        return String(stride(from: 0, to: Array(self).count, by: every).map {
            Array(Array(self)[$0..<min($0 + every, Array(self).count)])
        }.joined(separator: separator))
    }
}
