//
//  SearchError.swift
//  UserDefaults
//
//  Created by Vika on 30.07.25.
//

import Foundation

enum SearchError: Error, LocalizedError {
    case emptySearchTerm
    case saveFailed
    case deleteFailed
    case searchNotFound
    case storageError(StorageError)
    
    var errorDescription: String? {
        switch self {
        case .emptySearchTerm:
            return "Search term cannot be empty"
        case .saveFailed:
            return "Failed to save search"
        case .deleteFailed:
            return "Failed to delete search"
        case .searchNotFound:
            return "Search not found"
        case .storageError(let storageError):
            return "Search storage error: \(storageError.localizedDescription)"
        }
    }
}
