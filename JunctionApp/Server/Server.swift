//
//  Server.swift
//  JunctionApp
//
//  Created by Artem Belkov on 07.11.2020.
//

import UIKit

class Server {
    typealias RoomCompletion = (Room) -> Void
    typealias RoomStatusCompletion = (RoomStatus) -> Void
    typealias PlacesCompletion = ([Place]) -> Void

    static let current = Server()
    
    func createRoom(for user: User, completion: RoomCompletion) {
        completion(Room(id: 101))
    }
        
    func getRoomStatus(completion: RoomStatusCompletion) {
        completion(RoomStatus(voters: [], places: []))
    }
    
    func getFirstPlaces(completion: PlacesCompletion) {
        completion([])
    }
        
    func choosePlace(_ placeID: PlaceID, completion: PlacesCompletion) {
        completion([])
    }
}

struct User {
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

typealias RoomID = Int

struct Room {
    let id: RoomID
    let link: String
    
    init(id: RoomID) {
        self.id = id
        self.link = "takto://\(id)"
    }
}

typealias PlaceID = Int

struct Voter {
    let name: String
    let status: Status
    
    enum Status {
        case voting
        case finished
    }
}

struct Place {
    let name: String
    let photo: String
    let cuisines: [String]
    let isOpen: Bool
}

struct RoomStatus {
    let voters: [Voter]
    let places: [Place]
}
