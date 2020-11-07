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
            userDefaults.string(forKey: roomIDKey)
        }
        set {
            userDefaults.set(newValue, forKey: roomIDKey)
        }
    }
    
    var isJoined: Bool {
        get {
            userDefaults.bool(forKey: isJoinedKey)
        }
        set {
            userDefaults.set(newValue, forKey: isJoinedKey)
        }
    }
    
    private let userDefaults = UserDefaults.standard
    
    private let userNameKey = "userName"
    private let roomIDKey = "roomID"
    private let isJoinedKey = "isJoined"
}
