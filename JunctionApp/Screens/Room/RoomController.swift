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
    
    func showIntroduction() {
        guard let name = Storage.current.userName else { return }
        
        nameLabel.text = "Hi, \(name)"
    }
    
    private var state: State = .notCreated {
        didSet {
            updateButtons()
        }
    }
    
    private var room: Room?
    private var voters: [Voter]?
    private var results: [Place]?
    
    private func updateButtons() {
        print("Current state = \(state)")
        
        shareButton.animateHidden(!state.isShareVisible)
        shareButton.setTitle("Invite friends", for: .normal)
        shareButtonBottomConstraint.constant = state.isVoteVisible ? 76 : 16
        
        voteButton.animateHidden(!state.isVoteVisible)
        voteButton.isEnabled = state.isVoteEnabled
        voteButton.backgroundColor = state.isVoteEnabled ? #colorLiteral(red: 0.5960784314, green: 0.2588235294, blue: 0.3764705882, alpha: 1) : .lightGray
        voteButton.setTitle(state.voteTitle, for: .normal)

        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.view.layoutIfNeeded()
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
    
    private func checkState() {
        if Storage.current.roomID == nil {
            state = .notCreated
        } else {
            state = .created
        }
    }
    
    private func showShareSheet() {
        guard let room = room else { return }
        
        let sheet = UIActivityViewController(activityItems: [room.link], applicationActivities: nil)
        present(sheet, animated: true, completion: nil)
    }
    
    private func showVote() {
        // Show vote
    }
    
    private func showResults() {
        // Show results
    }
    
    @IBAction func inviteTapped(_ sender: Any) {
        if room != nil {
            showShareSheet()
        } else {
            guard let name = Storage.current.userName else { return }
            let user = User(name: name)
            
            Server.current.createRoom(for: user) { [unowned self] room in
                Storage.current.roomID = room.id
                self.room = room
                self.state = .created
                self.showShareSheet()
            }
        }
    }
    
    @IBAction func voteTapped(_ sender: Any) {
        if state == .result {
            showResults()
        } else if state == .created {
            showVote()
        }
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
