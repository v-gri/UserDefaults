//
//  SearchManager.swift
//  UserDefaults
//
//  Created by Vika on 29.07.25.
//

import Foundation

final class SearchManager: SearchServiceProtocol {
    
    static let shared = SearchManager()
    
    private let storage: SearchStorageProtocol
    private let recentSearchesKey = "recentSearches"
    
    let maxSearchCount = 5
    
    private init(storage: SearchStorageProtocol = SearchDefaultsStorage()) {
        self.storage = storage
    }
    
    func addSearch(_ searchTerm: String) throws {
        let trimmedTerm = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTerm.isEmpty else {
            throw SearchError.emptySearchTerm
        }
        
        do {
            var searches = try storage.getSearches()
            searches.removeAll { $0.lowercased() == trimmedTerm.lowercased() }
            searches.insert(trimmedTerm, at: 0)
            
            if searches.count > maxSearchCount {
                searches = Array(searches.prefix(maxSearchCount))
            }
            
            try storage.saveSearches(searches)
            
        } catch let error as SearchError {
            throw error
        } catch let error as StorageError {
            throw SearchError.storageError(error)
        } catch {
            throw SearchError.saveFailed
        }
    }
    
    func getRecentSearches() -> [String] {
        do {
            return try storage.getSearches()
        } catch {
            return []
        }
    }
    
    func removeSearch(_ searchTerm: String) throws {
        do {
            var searches = try storage.getSearches()
            
            guard let index = searches.firstIndex(of: searchTerm) else {
                throw SearchError.searchNotFound
            }
            
            searches.remove(at: index)
            try storage.saveSearches(searches)
            
        } catch let error as SearchError {
            throw error
        } catch let error as StorageError {
            throw SearchError.storageError(error)
        } catch {
            throw SearchError.deleteFailed
        }
    }
    
    func clearAllSearches() throws {
        do {
            try storage.deleteSearches()
        } catch let error as StorageError {
            throw SearchError.storageError(error)
        } catch {
            throw SearchError.deleteFailed
        }
    }
}
