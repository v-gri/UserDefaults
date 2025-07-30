//
//  WeakThemeObserver.swift
//  UserDefaults
//
//  Created by Vika on 30.07.25.
//


class WeakThemeObserver {
    weak var observer: ThemeObserver?
    
    init(_ observer: ThemeObserver) {
        self.observer = observer
    }
}
