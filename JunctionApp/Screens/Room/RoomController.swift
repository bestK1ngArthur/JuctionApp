//
//  RoomController.swift
//  JunctionApp
//
//  Created by Artem Belkov on 06.11.2020.
//

import UIKit

class RoomController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    private var state: State = .notCreated {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
    }
}

extension RoomController {
    
    enum State {
        case notCreated
        case created
        case waiting
        case result
    }
}
