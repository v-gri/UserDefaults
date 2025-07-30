//
//  UserStorageProtocol.swift
//  UserDefaults
//
//  Created by Vika on 30.07.25.
//


protocol UserStorageProtocol {
    func saveUser(email: String, isLoggedIn: Bool) throws
    func getUser() throws -> (email: String?, isLoggedIn: Bool)
    func deleteUser() throws
}