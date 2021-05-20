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
    private let numberOfSections = 2
    private let headerTitles = ["November 2015", "October 2015"]
    
    // MARK: - UI Properties
    @IBOutlet private weak var tableView: UITableView!
    private let searchBar = UISearchBar(placeholder: L10n.Main.NavBar.Search.title)
    private let categoryBarButtom = UIBarButtonItem(title: L10n.Main.NavBar.Category.title, style: .plain, target: self, action: nil)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Helpers
    static func newInstanse() -> TimelineViewController {
        let timelineVC = StoryboardScene.Timeline.timelineViewController.instantiate()
        return timelineVC
    }
    
    private func setupView() {
        tableView.tableFooterView = UIView()
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = categoryBarButtom
    }
    
}

// MARK: - UITable view data source
extension TimelineViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier,
                                                       for: indexPath) as? MarkerCell else { return UITableViewCell() }
        cell.markerImage.image = UIImage(systemName: "photo")
        cell.markerDescription.text = "My best friend show me his new Macbook Pro with M1"
        cell.markerDate.text = "11-16-15"
        cell.markerCategory.text = "FRIENDS"
        return cell
    }
    
}
