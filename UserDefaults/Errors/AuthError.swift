//
//  AuthError.swift
//  UserDefaults
//
//  Created by Vika on 30.07.25.
//

import Foundation

enum AuthError: Error, LocalizedError {
    case invalidEmail
    case loginFailed
    case logoutFailed
    case userNotFound
    case storageError(StorageError)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .loginFailed:
            return "Login failed. Please try again"
        case .logoutFailed:
            return "Logout failed. Please try again"
        case .userNotFound:
            return "User not found"
        case .storageError(let storageError):
            return "Storage error: \(storageError.localizedDescription)"
        }
    }
}
