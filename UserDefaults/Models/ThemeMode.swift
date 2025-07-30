//
//  ThemeMode.swift
//  UserDefaults
//
//  Created by Vika on 29.07.25.
//

enum ThemeMode: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}
