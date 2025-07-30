//
//  StorageError.swift
//  UserDefaults
//
//  Created by Vika on 30.07.25.
//

import Foundation

enum StorageError: Error, LocalizedError {
    case saveFailed(key: String)
    case loadFailed(key: String)
    case deleteFailed(key: String)
    case dataCorrupted(key: String)
    case keyNotFound(key: String)
    case encodingFailed
    case decodingFailed
    
    var errorDescription: String? {
        switch self {
        case .saveFailed(let key):
            return "Failed to save data for key: \(key)"
        case .loadFailed(let key):
            return "Failed to load data for key: \(key)"
        case .deleteFailed(let key):
            return "Failed to delete data for key: \(key)"
        case .dataCorrupted(let key):
            return "Data corrupted for key: \(key)"
        case .keyNotFound(let key):
            return "Key not found: \(key)"
        case .encodingFailed:
            return "Failed to encode data"
        case .decodingFailed:
            return "Failed to decode data"
        }
    }
}
