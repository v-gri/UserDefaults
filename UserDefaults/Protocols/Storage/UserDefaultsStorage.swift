//
//  UserDefaultsStorage.swift
//  UserDefaults
//
//  Created by Vika on 30.07.25.
//

import Foundation

class UserDefaultsStorage: UserStorageProtocol {
    private let emailKey = "userEmail"
    private let isLoggedInKey = "isLoggedIn"
    
    func saveUser(email: String, isLoggedIn: Bool) throws {
        UserDefaults.standard.set(email, forKey: emailKey)
        UserDefaults.standard.set(isLoggedIn, forKey: isLoggedInKey)
        
        guard UserDefaults.standard.synchronize() else {
            throw StorageError.saveFailed(key: emailKey)
        }
    }
    
    func getUser() throws -> (email: String?, isLoggedIn: Bool) {
        let email = UserDefaults.standard.string(forKey: emailKey)
        let isLoggedIn = UserDefaults.standard.bool(forKey: isLoggedInKey)
        return (email, isLoggedIn)
    }
    
    func deleteUser() throws {
        UserDefaults.standard.removeObject(forKey: emailKey)
        UserDefaults.standard.set(false, forKey: isLoggedInKey)
        
        guard UserDefaults.standard.synchronize() else {
            throw StorageError.deleteFailed(key: emailKey)
        }
    }
}
