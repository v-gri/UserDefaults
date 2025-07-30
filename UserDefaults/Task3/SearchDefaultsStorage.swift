//
//  SearchDefaultsStorage.swift
//  UserDefaults
//
//  Created by Vika on 30.07.25.
//

import Foundation

class SearchDefaultsStorage: SearchStorageProtocol {
    private let recentSearchesKey = "recentSearches"
    
    func saveSearches(_ searches: [String]) throws {
        UserDefaults.standard.set(searches, forKey: recentSearchesKey)
        
        guard UserDefaults.standard.synchronize() else {
            throw StorageError.saveFailed(key: recentSearchesKey)
        }
    }
    
    func getSearches() throws -> [String] {
        return UserDefaults.standard.stringArray(forKey: recentSearchesKey) ?? []
    }
    
    func deleteSearches() throws {
        UserDefaults.standard.removeObject(forKey: recentSearchesKey)
        
        guard UserDefaults.standard.synchronize() else {
            throw StorageError.deleteFailed(key: recentSearchesKey)
        }
    }
}
