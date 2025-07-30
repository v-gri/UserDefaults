//
//  ThemeManager.swift
//  UserDefaults
//
//  Created by Vika on 29.07.25.
//

import UIKit

final class ThemeManager: ThemeManagerProtocol {
    
    static let shared = ThemeManager()
    
    private let storage: ThemeStorageProtocol
    private let themeKey = "selectedTheme"
    private var observers: [WeakThemeObserver] = []
    
    private(set) var currentTheme: ThemeMode = .light
    
    static let themeChangedNotification = Notification.Name("ThemeChanged")
    
    private init(storage: ThemeStorageProtocol = ThemeDefaultsStorage()) {
        self.storage = storage
        self.currentTheme = getSavedTheme()
    }
    
    func saveTheme(_ theme: ThemeMode) throws {
        do {
            try storage.saveTheme(theme)
            currentTheme = theme
            applyTheme(theme)
            notifyObservers(theme)
            
            NotificationCenter.default.post(name: ThemeManager.themeChangedNotification, object: theme)
            
        } catch let error as StorageError {
            throw ThemeError.storageError(error)
        } catch {
            throw ThemeError.saveFailed
        }
    }
    
    func getSavedTheme() -> ThemeMode {
        do {
            return try storage.getTheme() ?? .light
        } catch {
            return .light
        }
    }
    
    func applyTheme(_ theme: ThemeMode) {
        currentTheme = theme
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        switch theme {
        case .light:
            window.overrideUserInterfaceStyle = .light
        case .dark:
            window.overrideUserInterfaceStyle = .dark
        }
    }
    
    func applySavedTheme() {
        let savedTheme = getSavedTheme()
        applyTheme(savedTheme)
    }
    
    func addObserver(_ observer: ThemeObserver) {
        removeObserver(observer)
        observers.append(WeakThemeObserver(observer))
        cleanupObservers()
    }
    
    func removeObserver(_ observer: ThemeObserver) {
        observers.removeAll { weakObserver in
            weakObserver.observer === observer
        }
    }
}

// MARK: - Private Methods
private extension ThemeManager {
    func notifyObservers(_ theme: ThemeMode) {
        cleanupObservers()
        
        observers.forEach { weakObserver in
            weakObserver.observer?.themeDidChange(to: theme)
        }
    }
    
    func cleanupObservers() {
        observers.removeAll { $0.observer == nil }
    }
}
