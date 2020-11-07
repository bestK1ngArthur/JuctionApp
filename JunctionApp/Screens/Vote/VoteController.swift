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
    
    var localPlaces: [Place]?
    
    override func viewDidLoad() {
        Server.current.getFirstPlaces { [weak self] (places) in
            if places.isEmpty {
                self?.dismiss(animated: true, completion: nil)
            } else {
                self?.localPlaces = places
                self?.firstCard?.configurateCard(place: places.first)
                self?.secondCard?.configurateCard(place: places.last)
            }
        }
    }
    
    @IBAction func chooseFirst() {
        firstCard?.startAnimation()
        Server.current.choosePlace(1) { [weak self] (places) in
            if places.isEmpty {
                self?.dismiss(animated: true, completion: nil)
            } else {
                self?.localPlaces = places
                self?.firstCard?.configurateCard(place: places.first)
            }
        }
    }
    
    @IBAction func chooseSecond() {
        print("presed")
        secondCard?.startAnimation()
        Server.current.choosePlace(1) { [weak self] (places) in
            if places.isEmpty {
                self?.dismiss(animated: true, completion: nil)
            } else {
                self?.localPlaces = places
                self?.secondCard?.configurateCard(place: places.last)
            }
        }
    }
    
}
