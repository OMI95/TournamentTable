//
//  MockTournamentTableViewModel.swift
//  TournamentTable
//
//  Created by Muhammad Omer on 30/10/2025.
//

@testable import TournamentTable

final class MockTournamentTableViewModel: TournamentTableViewModelProtocol {

    var standings: [TeamStanding]

    init(mockTeams: [TeamStanding] = []) {
        self.standings = mockTeams
    }

}
