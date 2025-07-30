//
//  ThemeStorageProtocol.swift
//  UserDefaults
//
//  Created by Vika on 30.07.25.
//


protocol ThemeStorageProtocol {
    func saveTheme(_ theme: ThemeMode) throws
    func getTheme() throws -> ThemeMode?
    func deleteTheme() throws
}