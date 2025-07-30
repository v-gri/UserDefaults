//
//  ThemeServiceProtocol.swift
//  UserDefaults
//
//  Created by Vika on 30.07.25.
//


import Foundation

protocol ThemeServiceProtocol {
    var currentTheme: ThemeMode { get }
    
    func saveTheme(_ theme: ThemeMode) throws
    func getSavedTheme() -> ThemeMode
    func applyTheme(_ theme: ThemeMode)
    func applySavedTheme()
}

protocol ThemeObserver: AnyObject {
    func themeDidChange(to theme: ThemeMode)
}

protocol ThemeManagerProtocol: ThemeServiceProtocol {
    func addObserver(_ observer: ThemeObserver)
    func removeObserver(_ observer: ThemeObserver)
}

