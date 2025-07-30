//
//  ThemeDefaultsStorage.swift
//  UserDefaults
//
//  Created by Vika on 30.07.25.
//

import Foundation

class ThemeDefaultsStorage: ThemeStorageProtocol {
    private let themeKey = "selectedTheme"
    
    func saveTheme(_ theme: ThemeMode) throws {
        UserDefaults.standard.set(theme.rawValue, forKey: themeKey)
        
        guard UserDefaults.standard.synchronize() else {
            throw StorageError.saveFailed(key: themeKey)
        }
    }
    
    func getTheme() throws -> ThemeMode? {
        guard let themeRawValue = UserDefaults.standard.string(forKey: themeKey) else {
            return nil
        }
        
        return ThemeMode(rawValue: themeRawValue)
    }
    
    func deleteTheme() throws {
        UserDefaults.standard.removeObject(forKey: themeKey)
        
        guard UserDefaults.standard.synchronize() else {
            throw StorageError.deleteFailed(key: themeKey)
        }
    }
}
