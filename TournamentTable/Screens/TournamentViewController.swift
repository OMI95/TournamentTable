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
    
    private let viewModel: TournamentTableViewModelProtocol
    
    private let rightHeaderContainer = UIView()
    
    private let headerLeftView: HeaderView = HeaderView.fromNib()
    private let headerRightView: HeaderRightView = HeaderRightView.fromNib()
    
    let leftTableView = UITableView()
    private let rightTableView = UITableView()
    
    private let headerRightScrollView = UIScrollView()
    private let rightScrollView = UIScrollView()
    
    private var isSyncing = false

    init(viewModel: TournamentTableViewModelProtocol = TournamentTableViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        
        // RightScrollView setup
        rightScrollView.alwaysBounceHorizontal = true
        rightScrollView.showsHorizontalScrollIndicator = true
        rightScrollView.delegate = self
        rightScrollView.backgroundColor = .systemBackground
        rightScrollView.addSubview(rightTableView)
        
        // Header scroll view setup
        headerRightScrollView.showsHorizontalScrollIndicator = false
        headerRightScrollView.delegate = self
        headerRightScrollView.backgroundColor = .systemGray5
        headerRightScrollView.addSubview(headerRightView)
        
        // Add subviews
        self.view.addSubview(headerLeftView)
        self.view.addSubview(headerRightScrollView)
        self.view.addSubview(leftTableView)
        self.view.addSubview(rightScrollView)
        
        headerLeftView.backgroundColor = .systemGray5
        headerRightView.backgroundColor = .systemGray5
    }
    
    private func setupLayout() {
        let headerHeight: CGFloat = 44
        let leftWidth: CGFloat = 200
        let rightContentWidth: CGFloat = 600 // Adjust based on columns in RightTableCell
        
        [headerLeftView, headerRightScrollView, headerRightView, leftTableView, rightScrollView, rightTableView].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Use layout guides for scroll views
        let headerContentLayout = headerRightScrollView.contentLayoutGuide
        let headerFrameLayout = headerRightScrollView.frameLayoutGuide
        
        let rightContentLayout = rightScrollView.contentLayoutGuide
        let rightFrameLayout = rightScrollView.frameLayoutGuide
        
        NSLayoutConstraint.activate([
            // Header left
            headerLeftView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerLeftView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerLeftView.widthAnchor.constraint(equalToConstant: leftWidth),
            headerLeftView.heightAnchor.constraint(equalToConstant: headerHeight),
            
            // Header right scroll view
            headerRightScrollView.leadingAnchor.constraint(equalTo: headerLeftView.trailingAnchor),
            headerRightScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerRightScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerRightScrollView.heightAnchor.constraint(equalToConstant: headerHeight),
            
            // Header right view inside scroll view (using contentLayoutGuide)
            headerRightView.leadingAnchor.constraint(equalTo: headerContentLayout.leadingAnchor),
            headerRightView.trailingAnchor.constraint(equalTo: headerContentLayout.trailingAnchor),
            headerRightView.topAnchor.constraint(equalTo: headerContentLayout.topAnchor),
            headerRightView.bottomAnchor.constraint(equalTo: headerContentLayout.bottomAnchor),
            headerRightView.widthAnchor.constraint(equalToConstant: rightContentWidth),
            // Match height to scroll view's visible height
            headerRightView.heightAnchor.constraint(equalTo: headerFrameLayout.heightAnchor),
            
            // Left table
            leftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftTableView.topAnchor.constraint(equalTo: headerLeftView.bottomAnchor),
            leftTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leftTableView.widthAnchor.constraint(equalToConstant: leftWidth),
            
            // Right scroll view
            rightScrollView.leadingAnchor.constraint(equalTo: leftTableView.trailingAnchor),
            rightScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rightScrollView.topAnchor.constraint(equalTo: headerRightScrollView.bottomAnchor),
            rightScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Right table inside scroll view (using contentLayoutGuide)
            rightTableView.leadingAnchor.constraint(equalTo: rightContentLayout.leadingAnchor),
            rightTableView.trailingAnchor.constraint(equalTo: rightContentLayout.trailingAnchor),
            rightTableView.topAnchor.constraint(equalTo: rightContentLayout.topAnchor),
            rightTableView.bottomAnchor.constraint(equalTo: rightContentLayout.bottomAnchor),
            rightTableView.widthAnchor.constraint(equalToConstant: rightContentWidth),
            // Match table height to scroll view visible height
            rightTableView.heightAnchor.constraint(equalTo: rightFrameLayout.heightAnchor)
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
        
        // Vertical sync
        if scrollView == leftTableView {
            rightTableView.contentOffset.y = leftTableView.contentOffset.y
        } else if scrollView == rightTableView {
            leftTableView.contentOffset.y = rightTableView.contentOffset.y
        }
        
        // Horizontal sync between header and right scroll
        if scrollView == rightScrollView {
            headerRightScrollView.contentOffset.x = rightScrollView.contentOffset.x
        } else if scrollView == headerRightScrollView {
            rightScrollView.contentOffset.x = headerRightScrollView.contentOffset.x
        }
        
        isSyncing = false
    }
}

@available(iOS 17.0, *)
#Preview {
    TournamentViewController()
}
