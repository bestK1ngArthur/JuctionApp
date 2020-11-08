//
//  VoteController.swift
//  JunctionApp
//
//  Created by Artem Belkov on 06.11.2020.
//

import Foundation
import UIKit

class VoteController: UIViewController {
    
    @IBOutlet weak var firstCard: CardView?
    @IBOutlet weak var secondCard: CardView?
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    
    var localPlaces: [Place]?
    var roomID: RoomID { Storage.current.roomID! }
    
    override func viewDidLoad() {
        
        firstButton.setBackgroundColor(UIColor.black.withAlphaComponent(0.4), for: .highlighted)
        secondButton.setBackgroundColor(UIColor.black.withAlphaComponent(0.4), for: .highlighted)

        Server.current.getFirstPlaces(for: roomID) { [weak self] places in
            self?.localPlaces = places
            self?.firstCard?.configurateCard(place: places.first)
            self?.secondCard?.configurateCard(place: places.last)
        }
    }
    
    @IBAction func chooseFirst() {
        
        secondCard?.startAnimation()
        Server.current.choosePlace(isFirstPlace: true, for: roomID) { [weak self] places in
            if places.isEmpty {
                self?.finish()
            } else {
                self?.localPlaces = places
                self?.secondCard?.configurateCard(place: places.first)
            }
        }
    }
    
    @IBAction func chooseSecond() {
        
        firstCard?.startAnimation()
        Server.current.choosePlace(isFirstPlace: false, for: roomID) { [weak self] places in
            if places.isEmpty {
                self?.finish()
            } else {
                self?.localPlaces = places
                self?.firstCard?.configurateCard(place: places.last)
            }
        }
    }
    
    private func finish() {
        dismiss(animated: true, completion: nil)
    }
}
