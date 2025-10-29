//
//  RightTableCell.swift
//  TournamentTable
//
//  Created by Muhammad Omer on 29/10/2025.
//

import UIKit

class RightTableCell: UITableViewCell {

    @IBOutlet var statLabels: [UILabel]!
 
    func configure(team: TeamStanding) {
        statLabels[0].text = "\(team.played)"
        statLabels[1].text = "\(team.won)"
        statLabels[2].text = "\(team.draw)"
        statLabels[3].text = "\(team.lost)"
        statLabels[4].text = "\(team.goalScored - team.goalAgainst)"
        statLabels[5].text = "\(team.points)"
    }
}
