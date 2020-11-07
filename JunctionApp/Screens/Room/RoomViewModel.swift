//
//  RoomViewModel.swift
//  JunctionApp
//
//  Created by Artem Belkov on 07.11.2020.
//

import Foundation

class RoomViewModel {
    
    var state: State = .notCreated
    var link: String?

    var votingIsVisible: Bool { state == .created }
    
    func createRoom(with name: String) {
        Server.current.createRoom(for: .init(name: name)) { [unowned self] room in
            self.state = .created
            self.link = room.link
        }
    }
}

extension RoomViewModel {
    
    enum State {
        case notCreated
        case created
        case waiting
        case result
    }
}
