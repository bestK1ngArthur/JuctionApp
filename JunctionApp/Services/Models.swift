//
//  Models.swift
//  JunctionApp
//
//  Created by Artem Belkov on 07.11.2020.
//

import UIKit

struct User: Codable, Equatable {
    let name: String
    let identifier: String
    
    init(name: String) {
        guard let identifier = UIDevice.current.identifierForVendor?.uuidString else {
            fatalError("Device identifier is nil")
        }
        
        self.name = name
        self.identifier = identifier
    }
}

typealias RoomID = String

struct Room: Codable, Equatable {
    let id: RoomID
    let voters: [Voter]
    
    var link: String { "takto://\(id)" }
    
    enum CodingKeys: String, CodingKey {
        case id = "room_id"
        case voters = "users"
    }
}

typealias PlaceID = Int

struct Voter: Codable, Equatable {
    let name: String
    let status: Status
    
    var initials: String {
        guard let firstLetter = name.first else { return "" }
        return String(firstLetter)
    }
    
    enum Status: String, Codable, Equatable {
        case voting
        case finished
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "username"
        case status
    }
}

struct Place: Codable, Equatable {
    let name: String
    let photo: String
    let cuisines: [String]
    let isOpen: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case photo = "business_id"
        case cuisines
        case isOpen = "is_open"
    }
}

struct RoomStatus: Codable, Equatable {
    let voters: [Voter]
    let places: [Place]
}
