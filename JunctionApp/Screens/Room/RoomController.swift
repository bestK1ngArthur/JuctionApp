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

        checkState()
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
        shareButton.isHidden = !state.isShareVisible
        shareButton.setTitle("Invite friends", for: .normal)
        shareButtonBottomConstraint.constant = state.isVoteVisible ? 76 : 16
        
        voteButton.isHidden = !state.isVoteVisible
        voteButton.isEnabled = state.isVoteEnabled
        voteButton.backgroundColor = state.isVoteEnabled ? #colorLiteral(red: 0.5960784314, green: 0.2588235294, blue: 0.3764705882, alpha: 1) : .lightGray
        voteButton.setTitle(state.voteTitle, for: .normal)
        
        print(state)
    }
    
    private func showNamePopupIfNeeded() {
        guard Storage.current.userName == nil,
              let popup = storyboard?.instantiateViewController(identifier: String(describing: NamePopupController.self)) else {
            return
        }
        
        popup.modalPresentationStyle = .overFullScreen
        
        present(popup, animated: false, completion: nil)
    }
    
    private func checkState() {
        if Storage.current.roomID == nil {
            state = .notCreated
        } else {
            state = .created
        }
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
        
        var isShareVisible: Bool {
            switch self {
            case .notCreated, .created, .waiting: return true
            case .result: return false
            }
        }
        
        var isVoteVisible: Bool {
            switch self {
            case .notCreated: return false
            case .created, .waiting, .result: return true
            }
        }
        
        var isVoteEnabled: Bool {
            switch self {
            case .notCreated, .created, .result: return true
            case .waiting: return false
            }
        }
        
        var voteTitle: String {
            switch self {
            case .notCreated, .created: return "Start choosing"
            case .waiting, .result: return "Show suggestions"
            }
        }
    }
}
