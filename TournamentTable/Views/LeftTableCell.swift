//
//  LeftTableCell.swift
//  TournamentTable
//
//  Created by Muhammad Omer on 29/10/2025.
//

import UIKit

class LeftTableCell: UITableViewCell {

    @IBOutlet weak var posLabel: UILabel!
    @IBOutlet weak var clubLabel: UILabel!
    
    func configure(position: Int, club: String) {
        posLabel.text = "\(position)"
        clubLabel.text = club
        clubLabel.numberOfLines = 0
        clubLabel.lineBreakMode = .byWordWrapping
    }
}
