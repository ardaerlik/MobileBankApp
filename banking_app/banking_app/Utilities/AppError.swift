//
//  AppError.swift
//  banking_app
//
//  Created by Can Koz on 16.12.2021.
//

import Foundation

enum AppError: String, Error {
    case invalidPassword  = "Invalid password. Please try again."
    case invalidCredentials  = "Invalid credentials. Please try again."
}
