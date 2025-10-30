//
//  TournamentTableTests.swift
//  TournamentTableTests
//
//  Created by Muhammad Omer on 30/10/2025.
//

import XCTest
@testable import TournamentTable

final class TournamentTableTests: XCTestCase {

    func testViewControllerUsesInjectedMockViewModel() {
        let mockTeams = [
            TeamStanding(position: 1, clubName: "Mock United", played: 10, won: 7, draw: 2, lost: 1, goalScored: 25, goalAgainst: 10, goalDiff: 15, points: 23),
            TeamStanding(position: 2, clubName: "Mock City", played: 10, won: 6, draw: 3, lost: 1, goalScored: 22, goalAgainst: 12, goalDiff: 10, points: 21)
        ]
        let mockVM = MockTournamentTableViewModel(mockTeams: mockTeams)
        let sut = TournamentViewController(viewModel: mockVM)
        _ = sut.view

        let rows = sut.tableView(sut.leftTableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rows, mockTeams.count)
    }
}
