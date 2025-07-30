//
//  StorageProtocol.swift
//  UserDefaults
//
//  Created by Vika on 30.07.25.
//


protocol StorageProtocol {
    func save<T: Codable>(_ object: T, forKey key: String) throws
    func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> T?
    func delete(forKey key: String) throws
    func exists(forKey key: String) -> Bool
}
