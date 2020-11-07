//
//  Storage.swift
//  JunctionApp
//
//  Created by Artem Belkov on 07.11.2020.
//

import Foundation

class Storage {
    
    static let current = Storage()
    
    var userName: String? {
        get {
            userDefaults.string(forKey: userNameKey)
        }
        set {
            userDefaults.set(newValue, forKey: userNameKey)
        }
    }
    
    var roomID: RoomID? {
        get {
            userDefaults.value(forKey: roomIDKey) as? Int
        }
        set {
            userDefaults.set(newValue, forKey: roomIDKey)
        }
    }
    
    private let userDefaults = UserDefaults.standard
    
    private let userNameKey = "userName"
    private let roomIDKey = "roomID"
}
