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
    
    func createRoom(for user: User, completion: @escaping RoomCompletion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            completion(Room(id: 101))
        }
    }
        
    func getRoomStatus(for roomID: RoomID, completion: @escaping RoomStatusCompletion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            completion(RoomStatus(voters: [
                .init(name: "Ivan", status: .voting),
                .init(name: "Katya", status: .finished)
            ], places: []))
        }
    }
    
    func getFirstPlaces(completion: PlacesCompletion) {
        completion([])
    }
        
    func choosePlace(_ placeID: PlaceID, completion: PlacesCompletion) {
        completion([])
    }
}

struct User: Equatable {
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

struct Room: Equatable {
    let id: RoomID
    let link: String
    
    init(id: RoomID) {
        self.id = id
        self.link = "takto://\(id)"
    }
}

typealias PlaceID = Int

struct Voter: Equatable {
    let name: String
    let status: Status
    
    var initials: String {
        guard let firstLetter = name.first else { return "" }
        return String(firstLetter)
    }
    
    enum Status: String, Equatable {
        case voting
        case finished
    }
}

struct Place: Equatable {
    let name: String
    let photo: String
    let cuisines: [String]
    let isOpen: Bool
}

struct RoomStatus: Equatable {
    let voters: [Voter]
    let places: [Place]
}
