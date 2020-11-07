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
        
    func getRoomStatus(completion: RoomStatusCompletion) {
        completion(RoomStatus(voters: [], places: []))
    }
    
    func getFirstPlaces(completion: @escaping PlacesCompletion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            let place = [Place(name: "Macdonalds", photo: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80", cuisines: ["hui","pizda","scovoroda"], isOpen: true),
                         Place(name: "Ocherednaya Pomoika", photo: "https://d2w1ef2ao9g8r9.cloudfront.net/images/floorplan.png?mtime=20200424135830&focal=none", cuisines: ["pizda","scovoroda"], isOpen: false)]
            completion(place)
        }

    }
        
    func choosePlace(_ placeID: PlaceID, completion: @escaping PlacesCompletion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            let place = [Place(name: "Macdonalds2", photo: "https://lh3.googleusercontent.com/proxy/uDypGXLa53HqrzdJxwG9kZbblKS4pqGTbnrp4qUUSTi2rvGUEKEibAlOSIOlAG8LRb3yuGyrlADyQ_s5swehKc7944XPdRf6kbX7GOSgCu0dBXQ76EUwWfnPTP97Sdts8NHoKZ1_e_9lxoFdRw", cuisines: ["hui","pizda","scovoroda"], isOpen: true),
                         Place(name: "Ocherednaya Pomoika 2", photo: "https://restaurantdupalaisroyal.com/wp-content/uploads/2020/02/Restaurant_du_Palais_Royal_RDC_11_GdeLaubier.jpg", cuisines: ["pizda","scovoroda"], isOpen: false)]
            completion(place)
        }
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
