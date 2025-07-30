//
//  AuthManager.swift
//  UserDefaults
//
//  Created by Vika on 29.07.25.
//

import Foundation

final class AuthManager: AuthServiceProtocol {
    
    static let shared = AuthManager()
    
    private let storage: UserStorageProtocol
    private let emailKey = "userEmail"
    private let isLoggedInKey = "isLoggedIn"
    
    var isLoggedIn: Bool {
        do {
            let userData = try storage.getUser()
            return userData.isLoggedIn
        } catch {
            return false
        }
    }
    
    var userEmail: String? {
        do {
            let userData = try storage.getUser()
            return userData.email
        } catch {
            return nil
        }
    }
    
    private init(storage: UserStorageProtocol = UserDefaultsStorage()) {
        self.storage = storage
    }
    
    func login(email: String) throws {
        guard !email.isEmpty else {
            throw AuthError.invalidEmail
        }
        
        guard isValidEmail(email) else {
            throw AuthError.invalidEmail
        }
        
        do {
            try storage.saveUser(email: email, isLoggedIn: true)
        } catch {
            throw AuthError.loginFailed
        }
    }
    
    func logout() throws {
        do {
            try storage.deleteUser()
            
            if let searchManager = SearchManager.shared as? SearchServiceProtocol {
                try searchManager.clearAllSearches()
            }
            
            if let themeManager = ThemeManager.shared as? ThemeServiceProtocol {
                try themeManager.saveTheme(.light)
            }
            
        } catch {
            throw AuthError.logoutFailed
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
