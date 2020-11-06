//
//  Server.swift
//  JunctionApp
//
//  Created by Artem Belkov on 07.11.2020.
//

import Foundation

class Server {
    
    static let current = Server()
    
    typealias RoomCompletion = (Int) -> Void
    
    func createRoom(completion: RoomCompletion) {
        completion(101)
    }
    
    typealias RoomStatusCompletion = ([Any]) -> Void
    
    func getRoomStatus(completion: RoomStatusCompletion) {
        completion([])
    }

    typealias PlacesCompletion = ([Any]) -> Void
    
    func getFirstPlaces(completion: PlacesCompletion) {
        completion([])
    }
        
    func choosePlace(_ place: Int, completion: PlacesCompletion) {
        completion([])
    }
}

