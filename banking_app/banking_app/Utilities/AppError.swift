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
    case samePassword = "Enter a different from old password. Please try again."
    case databaseUpdateError = "Database has not been updated. Please try again."
    case investmentsError = "Investments info has not fetched"
    case transfersError = "Transfers info has not fetched"
    case emptyInput = "Please enter a non-blank value"
}

enum TransferError: String, Error {
    case insufficientBalance = "Your account has an insufficient balance."
    case invalidTckn = "Invalid TCKN. Please try again."
    case invalidIban = "Invalid IBAN. Please try again."
    case invalidAccountType = "Invalid account type. Please try again with another account "
    case databaseError = "Database error occured"
}
