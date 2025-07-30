//
//  ThemeError.swift
//  UserDefaults
//
//  Created by Vika on 30.07.25.
//

import Foundation

enum ThemeError: Error, LocalizedError {
    case saveFailed
    case invalidTheme
    case applicationFailed
    case storageError(StorageError)
    
    var errorDescription: String? {
        switch self {
        case .saveFailed:
            return "Failed to save theme preference"
        case .invalidTheme:
            return "Invalid theme selected"
        case .applicationFailed:
            return "Failed to apply theme"
        case .storageError(let storageError):
            return "Theme storage error: \(storageError.localizedDescription)"
        }
    }
}
