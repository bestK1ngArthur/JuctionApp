//
//  ResultTableViewCell.swift
//  JunctionApp
//
//  Created by admin on 07.11.2020.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardView: CardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configurateCell(place: Place?) {
        cardView.configurateCard(place: place)
    }

}
