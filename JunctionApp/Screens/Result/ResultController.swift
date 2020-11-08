//
//  ResultController.swift
//  JunctionApp
//
//  Created by Artem Belkov on 06.11.2020.
//

import Foundation
import UIKit

class ResultController: UIViewController {
    var places: [Place]? = []
    
    @IBOutlet weak var tableView: UITableView!
    
    var roomID: RoomID { Storage.current.roomID! }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Server.current.getRecommendedPlaces(for: roomID) { [weak self] places in
            var newPlaces: [Place] = []
            
            places.forEach { place in
                if newPlaces.contains(where: { $0.name == place.name }) {
                    return
                }
                
                newPlaces.append(place)
            }
            
            self?.places = newPlaces
            self?.tableView.reloadData()
        }
    }
}

extension ResultController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell") as? ResultTableViewCell
        cell?.configurateCell(place: places?[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 397
    }
    
}
