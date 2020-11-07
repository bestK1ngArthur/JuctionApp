//
//  RoomController.swift
//  JunctionApp
//
//  Created by Artem Belkov on 06.11.2020.
//

import UIKit

class RoomController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var votersCollectionView: UICollectionView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var voteButton: UIButton!
    
    @IBOutlet weak var shareButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        votersCollectionView.dataSource = self
        
        checkStartupState()
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
    
    func checkStartupState() {
        if let roomID = Storage.current.roomID {
            room = Room(id: roomID)
            state = .created
            startTimer()
        } else {
            state = .notCreated
        }
    }
    
    private var updateTimer: Timer?
    
    private var state: State = .notCreated {
        didSet {
            updateButtons()
        }
    }
    
    private var room: Room?
    
    private var voters: [Voter]? {
        didSet {
            guard voters != oldValue else { return }
            votersCollectionView.reloadData()
        }
    }
    
    private var results: [Place]?
    
    private func updateButtons() {
        shareButton.animateHidden(!state.isShareVisible)
        shareButton.setTitle("Invite friends", for: .normal)
        shareButtonBottomConstraint.constant = state.isVoteVisible ? 76 : 16
        
        voteButton.animateHidden(!state.isVoteVisible)
        voteButton.isEnabled = state.isVoteEnabled
        voteButton.backgroundColor = state.isVoteEnabled ? #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1) : .lightGray
        voteButton.setTitle(state.voteTitle, for: .normal)

        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
    
    private func startTimer() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [unowned self] _ in
            self.loadVoters()
        })
    }

    @objc private func loadVoters() {
        guard let roomID = room?.id else { return }
        
        Server.current.getRoomStatus(for: roomID) { [unowned self] status in
            self.voters = status.voters
            self.results = status.places
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
    
    private func showShareSheet() {
        guard let room = room else { return }
        
        let sheet = UIActivityViewController(activityItems: [room.link], applicationActivities: nil)
        present(sheet, animated: true, completion: nil)
    }
        
    private func showVote() {
        performSegue(withIdentifier: "Vote", sender: self)
    }
    
    private func showResults() {
        performSegue(withIdentifier: "Result", sender: self)
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
                self.showShareSheet()
                self.state = .created
                self.startTimer()
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
    
    enum State: Equatable {
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

extension RoomController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return voters?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RoomVooterCell.self),
                                                            for: indexPath) as? RoomVooterCell,
              let voters = voters, !voters.isEmpty else {
            return UICollectionViewCell()
        }
        
        let voter = voters[indexPath.row]
        cell.configure(with: voter)
        
        return cell
    }
}
