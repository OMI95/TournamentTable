//
//  TournamentViewController.swift
//  TournamentTable
//
//  Created by Muhammad Omer on 29/10/2025.
//

import UIKit
import SwiftUI

class TournamentViewController: UIViewController, UITableViewDelegate {
    
    // MARK: - Properties
    
    private let viewModel = TournamentTableViewModel()
    
    private let rightHeaderContainer = UIView()
    
    private let headerLeftView: HeaderView = HeaderView.fromNib()
    private let headerRightView: HeaderRightView = HeaderRightView.fromNib()
    
    private let leftTableView = UITableView()
    private let rightScrollView = UIScrollView()
    private let rightTableView = UITableView()
    
    private var isSyncing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tournament Table"
        self.setupViews()
        self.setupLayout()
    }
    
    
}

// MARK: - Setup
extension TournamentViewController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        // Register table cells
        self.leftTableView.register(UINib(nibName: "LeftTableCell", bundle: nil), forCellReuseIdentifier: "LeftTableCell")
        self.rightTableView.register(UINib(nibName: "RightTableCell", bundle: nil), forCellReuseIdentifier: "RightTableCell")
        
        leftTableView.rowHeight = UITableView.automaticDimension
        leftTableView.estimatedRowHeight = 44
        rightTableView.rowHeight = UITableView.automaticDimension
        rightTableView.estimatedRowHeight = 44
        
        self.leftTableView.dataSource = self
        self.rightTableView.dataSource = self
        self.leftTableView.delegate = self
        self.rightTableView.delegate = self
        
        // ScrollView setup
        rightScrollView.alwaysBounceHorizontal = true
        rightScrollView.showsHorizontalScrollIndicator = true
        rightScrollView.delegate = self
        rightScrollView.backgroundColor = .systemBackground
        
        // Add subviews
        self.rightScrollView.addSubview(self.rightTableView)
        self.view.addSubview(self.headerLeftView)
        self.view.addSubview(self.headerRightView)
        self.view.addSubview(self.leftTableView)
        self.view.addSubview(self.rightScrollView)
        
        headerLeftView.backgroundColor = .systemGray5
        headerRightView.backgroundColor = .systemGray5
    }
    
    private func setupLayout() {
        let headerHeight: CGFloat = 44
        let leftWidth: CGFloat = 200
        
        [headerLeftView, headerRightView, leftTableView, rightScrollView, rightTableView].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Header left
            headerLeftView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerLeftView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerLeftView.widthAnchor.constraint(equalToConstant: leftWidth),
            headerLeftView.heightAnchor.constraint(equalToConstant: headerHeight),
            
            // Header right
            headerRightView.leadingAnchor.constraint(equalTo: headerLeftView.trailingAnchor),
            headerRightView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerRightView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerRightView.heightAnchor.constraint(equalToConstant: headerHeight),
            
            // Left table
            leftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftTableView.topAnchor.constraint(equalTo: headerLeftView.bottomAnchor),
            leftTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leftTableView.widthAnchor.constraint(equalToConstant: leftWidth),
            
            // Right scroll view
            rightScrollView.leadingAnchor.constraint(equalTo: leftTableView.trailingAnchor),
            rightScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rightScrollView.topAnchor.constraint(equalTo: headerRightView.bottomAnchor),
            rightScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Right table (inside scroll view)
            rightTableView.topAnchor.constraint(equalTo: rightScrollView.topAnchor),
            rightTableView.leadingAnchor.constraint(equalTo: rightScrollView.leadingAnchor),
            rightTableView.trailingAnchor.constraint(equalTo: rightScrollView.trailingAnchor),
            rightTableView.bottomAnchor.constraint(equalTo: rightScrollView.bottomAnchor),
            rightTableView.widthAnchor.constraint(equalToConstant: 600),
            rightTableView.heightAnchor.constraint(equalTo: rightScrollView.heightAnchor)
        ])
    }
}

// MARK: - DataSource
extension TournamentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.standings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let team = self.viewModel.standings[indexPath.row]
        
        if tableView == leftTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftTableCell", for: indexPath) as! LeftTableCell
            cell.configure(position: team.position, club: team.clubName)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightTableCell", for: indexPath) as! RightTableCell
            cell.configure(team: team)
            return cell
        }
    }
    
}

// MARK: - Scroll Sync
extension TournamentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isSyncing else { return }
        isSyncing = true
        if scrollView == leftTableView {
            rightTableView.contentOffset.y = leftTableView.contentOffset.y
        } else if scrollView == rightTableView {
            leftTableView.contentOffset.y = rightTableView.contentOffset.y
        }
        
        isSyncing = false
    }
}

@available(iOS 17.0, *)
#Preview {
    TournamentViewController()
}
