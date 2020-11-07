//
//  VoterView.swift
//  JunctionApp
//
//  Created by Artem Belkov on 07.11.2020.
//

import UIKit

class RoomVooterCell: UICollectionViewCell {
    
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var circleView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        circleView.layer.cornerRadius = 30
    }
    
    func configure(with voter: Voter) {
        initialsLabel.text = voter.initials
        nameLabel.text = voter.name
        statusLabel.text = voter.status.rawValue
    }
}
