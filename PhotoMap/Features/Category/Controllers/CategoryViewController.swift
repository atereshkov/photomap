//
//  CategoryViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit

class CategoryViewController: BaseViewController {
    
    // MARK: - Variables
    private var viewModel: CategoryViewModelType?
    private var cancelBag = CancelBag()
    
    // MARK: - @IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    private lazy var doneButton = UIBarButtonItem(title: L10n.Categories.NavigationItem.RightButtonItem.done,
                                                  style: .done, target: self, action: nil)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
        viewModel?.viewDidLoadSubject.send()
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        viewModel.reloadDataSubject.sink(receiveValue: { [weak self] in
            self?.tableView.reloadData()
        })
        .store(in: cancelBag)
        
        doneButton.publisher
            .subscribe(viewModel.doneButtonSubject)
            .store(in: cancelBag)
        
        viewModel.loadingPublisher.sink(receiveValue: { [weak self] isLoading in
            isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        })
        .store(in: cancelBag)
    }
    
    // MARK: - Helpers
    static func newInstance(viewModel: CategoryViewModelType) -> CategoryViewController {
        let categoryVC = StoryboardScene.Category.categoryViewController.instantiate()
        categoryVC.viewModel = viewModel
        return categoryVC
    }
    
    private func setupViews() {
        tableView.tableFooterView = UIView()
        navigationItem.rightBarButtonItem = doneButton
    }
}

// MARK: - UITable View Data Source
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier,
                                                    for: indexPath) as? CategoryCell else { return UITableViewCell() }
        guard let category = viewModel?.getCategory(at: indexPath) else { return UITableViewCell() }
        cell.configure(with: category)
        return cell
    }
}

// MARK: - UITable View Delegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectRow(at: indexPath)
    }
}
