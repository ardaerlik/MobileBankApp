//
//  DoubleExtension.swift
//  banking_app
//
//  Created by Can Koz on 22.12.2021.
//

import Foundation

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
