//
//  SearchServiceProtocol.swift
//  UserDefaults
//
//  Created by Vika on 30.07.25.
//


import Foundation

protocol SearchServiceProtocol {
    var maxSearchCount: Int { get }
    
    func addSearch(_ searchTerm: String) throws
    func getRecentSearches() -> [String]
    func removeSearch(_ searchTerm: String) throws
    func clearAllSearches() throws
}
