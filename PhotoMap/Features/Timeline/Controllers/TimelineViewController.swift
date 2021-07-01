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
    private var viewModel: TimelineViewModelType?
    private let cancelBag = CancelBag()
    
    // MARK: - UI Properties
    @IBOutlet private weak var tableView: UITableView!
    private let searchBar = UISearchBar(placeholder: L10n.Main.NavBar.Search.title)
    private lazy var categoryBarButton = UIBarButtonItem(title: L10n.Main.NavBar.Category.title,
                                                         style: .plain, target: self, action: nil)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
        viewModel?.viewDidLoadSubject.send()
        tableView.keyboardDismissMode = .onDrag
    }
    
    // MARK: - Helpers
    static func newInstanse(viewModel: TimelineViewModelType) -> TimelineViewController {
        let timelineVC = StoryboardScene.Timeline.timelineViewController.instantiate()
        timelineVC.viewModel = viewModel
        return timelineVC
    }
    
    private func setupView() {
        tableView.tableFooterView = UIView()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = categoryBarButton
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        viewModel.reloadDataSubject.sink(receiveValue: { [weak self] in
            self?.tableView.reloadData()
        })
        .store(in: cancelBag)
        
        viewModel.loadingPublisher.sink(receiveValue: { [weak self] isLoading in
            isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        })
        .store(in: cancelBag)
        
        categoryBarButton.publisher
            .subscribe(viewModel.categoryButtonSubject)
            .store(in: cancelBag)
    }
    
}

// MARK: - UITable view data source
extension TimelineViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.getTitle(for: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MarkerCell.identifier,
                                                       for: indexPath) as? MarkerCell else { return UITableViewCell() }
        guard let marker = viewModel?.getMarker(at: indexPath) else { return UITableViewCell() }
        cell.viewModel = viewModel?.createCellViewModel(with: marker)
        return cell
    }
    
}

// MARK: - UITable view delegate
extension TimelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.didSelectRowSubject.send(indexPath)
    }
}

// MARK: - UISearchBarDelegate
extension TimelineViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchTextSubject.send(searchText)

        if searchText.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                searchBar.endEditing(true)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
