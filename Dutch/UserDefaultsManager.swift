//
//  UserDefaultsManager.swift
//  Dutch
//
//  Created by Apple on 31/07/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    private static let useDarkThemeKey = "useDarkThemeKey"
    private static let nameKey = "nameKey"
    private static let phoneKey = "phoneKey"
    private static let emailKey = "emailKey"
    private static let avatarKey = "avatarKey"
    private static let userKey = "userKey"
    
    static var useDarkTheme: Bool {
        get {
            return UserDefaults.standard.bool(forKey: useDarkThemeKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: useDarkThemeKey)
        }
    }
    
    static var userName: String {
        get {
            return UserDefaults.standard.string(forKey: nameKey)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nameKey)
        }
    }
    
    static var userPhone: String {
        get {
            return UserDefaults.standard.string(forKey: phoneKey)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: phoneKey)
        }
    }
    
    static var userEmail: String {
        get {
            return UserDefaults.standard.string(forKey: emailKey)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: emailKey)
        }
    }
    
    static var userAvatar: String {
        get {
            return UserDefaults.standard.string(forKey: avatarKey)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: avatarKey)
        }
    }
    
    static var userModel: Dictionary<String, Any> {
        get {
            return UserDefaults.standard.object(forKey: userKey) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userKey)
        }
    }
    
    static var testModel: Dictionary<String, Any> {
        get {
            return UserDefaults.standard.object(forKey: "test") as? Dictionary<String, Any> ?? Dictionary<String, Any>()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "test")
        }
    }
    
    
    
    
}
