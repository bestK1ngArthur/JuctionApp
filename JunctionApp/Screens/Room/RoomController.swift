//
//  RoomController.swift
//  JunctionApp
//
//  Created by Artem Belkov on 06.11.2020.
//

import UIKit

class RoomController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var voteButton: UIButton!
    
    @IBOutlet weak var shareButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showIntroduction()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showNamePopupIfNeeded()
    }
    
    private var state: State = .notCreated {
        didSet {
            stateUpdated()
        }
    }
    
    private func stateUpdated() {
        
        switch state {
        case .notCreated:
            break
        case .created:
            break
        case .waiting:
            break
        case .result:
            break
        }
        
    }
    
    private func showNamePopupIfNeeded() {
        guard Storage.current.userName == nil,
              let popup = storyboard?.instantiateViewController(identifier: String(describing: NamePopupController.self)) else {
            return
        }
        
        popup.modalPresentationStyle = .overFullScreen
        
        present(popup, animated: false, completion: nil)
    }
    
    private func showIntroduction() {
        guard let name = Storage.current.userName else { return }
        
        nameLabel.text = "Hi, \(name)"
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
