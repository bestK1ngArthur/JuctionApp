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
    override func viewDidLoad() {
        Server.current.getFirstPlaces { [weak self] (places) in
            if places.isEmpty {
                self?.dismiss(animated: true, completion: nil)
            } else {
                self?.places = places
                self?.tableView.reloadData()
            }
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
