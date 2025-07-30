//
//  AuthServiceProtocol.swift
//  UserDefaults
//
//  Created by Vika on 30.07.25.
//

import Foundation

protocol AuthServiceProtocol {
    var isLoggedIn: Bool { get }
    var userEmail: String? { get }
    
    func login(email: String) throws
    func logout() throws
    func isValidEmail(_ email: String) -> Bool
}

