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
    
    // MARK: - @IBOutlets
    private lazy var doneButton = UIBarButtonItem(title: L10n.Categories.NavigationItem.RightButtonItem.done,
                                                  style: .done, target: self, action: #selector(doneButtonPressed))
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - @IBActions
    @IBAction func categoryCheckBoxPressed(_ sender: UIButton) {
        viewModel?.didPressedButton(with: sender)
    }
    
    // MARK: - Helpers
    static func newInstance(viewModel: CategoryViewModelType) -> CategoryViewController {
        let categoryVC = StoryboardScene.Category.categoryViewController.instantiate()
        categoryVC.viewModel = viewModel
        return categoryVC
    }
    
    private func setupViews() {
        navigationItem.rightBarButtonItem = doneButton
    }
    
    // MARK: - Selectors
    @objc private func doneButtonPressed() {
        viewModel?.doneButtonSubject.send()
    }
}
