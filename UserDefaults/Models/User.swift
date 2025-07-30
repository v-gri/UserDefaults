//
//  User.swift
//  UserDefaults
//
//  Created by Vika on 29.07.25.
//


import Foundation

struct User {
    let email: String
    let loginDate: Date
    
    init(email: String) {
        self.email = email
        self.loginDate = Date()
    }
}