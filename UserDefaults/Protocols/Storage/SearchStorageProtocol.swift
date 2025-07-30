//
//  SearchStorageProtocol.swift
//  UserDefaults
//
//  Created by Vika on 30.07.25.
//


protocol SearchStorageProtocol {
    func saveSearches(_ searches: [String]) throws
    func getSearches() throws -> [String]
    func deleteSearches() throws
}