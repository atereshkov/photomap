//
//  TimelineViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit
import Combine

class TimelineViewController: BaseViewController {
    
    // MARK: - Variables
    private struct Constants {
        static let cellIdentifier = "markerCell"
    }
    private var viewModel: TimelineViewModelType?
    
    // MARK: - UI Properties
    @IBOutlet private weak var tableView: UITableView!
    private let searchBar = UISearchBar(placeholder: L10n.Main.NavBar.Search.title)
    private let categoryBarButton = UIBarButtonItem(title: L10n.Main.NavBar.Category.title, style: .plain, target: self, action: nil)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Helpers
    static func newInstanse(viewModel: TimelineViewModelType) -> TimelineViewController {
        let timelineVC = StoryboardScene.Timeline.timelineViewController.instantiate()
        timelineVC.viewModel = viewModel
        return timelineVC
    }
    
    private func setupView() {
        tableView.tableFooterView = UIView()
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = categoryBarButton
    }
    
}

// MARK: - UITable view data source
extension TimelineViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.headerTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier,
                                                       for: indexPath) as? MarkerCell else { return UITableViewCell() }
        cell.configure()
        return cell
    }
    
}
