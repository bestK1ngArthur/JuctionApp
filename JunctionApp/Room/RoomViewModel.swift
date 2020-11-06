//
//  RoomViewModel.swift
//  JunctionApp
//
//  Created by Artem Belkov on 07.11.2020.
//

import Foundation

struct RoomViewModel {
    
    var state: State = .notCreated
    
}

extension RoomViewModel {
    
    enum State {
        case notCreated
        case created
        case waiting
        case result
    }
}
