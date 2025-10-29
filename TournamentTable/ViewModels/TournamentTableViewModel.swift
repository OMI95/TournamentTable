//
//  TournamentTableViewModel.swift
//  TournamentTable
//
//  Created by Muhammad Omer on 29/10/2025.
//

final class TournamentTableViewModel {
    private(set) var standings: [TeamStanding] = []

    init() {
        loadMockData()
    }

    private func loadMockData() {
        standings = [
            TeamStanding(position: 1, clubName: "Liver Pool", played: 25, won: 18, draw: 6, lost: 1, goalScored: 60, goalAgainst: 25, goalDiff: 36, points: 60),
            TeamStanding(position: 2, clubName: "Arsenal", played: 25, won: 15, draw: 8, lost: 2, goalScored: 51, goalAgainst: 22, goalDiff: 29, points: 53),
            TeamStanding(position: 3, clubName: "Nottm Forest", played: 25, won: 14, draw: 5, lost: 6, goalScored: 41, goalAgainst: 29, goalDiff: 12, points: 47),
            TeamStanding(position: 4, clubName: "Man City", played: 25, won: 13, draw: 5, lost: 7, goalScored: 52, goalAgainst: 35, goalDiff: 17, points: 44),
            TeamStanding(position: 5, clubName: "Bournemouth", played: 25, won: 12, draw: 7, lost: 6, goalScored: 44, goalAgainst: 29, goalDiff: 15, points: 43)
        ]
    }

}
