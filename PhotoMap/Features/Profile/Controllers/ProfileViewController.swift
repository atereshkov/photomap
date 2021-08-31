//
//  ProfileViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit
import Combine

class ProfileViewController: BaseViewController {
    // MARK: - Variables
    var viewModel: ProfileViewModelType?
    private let cancelBag = CancelBag()
    
    // MARK: - @IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    private lazy var logoutButton: UIBarButtonItem = {
        let logoutButton = UIBarButtonItem(title: L10n.Logout.Button.Title.logOut, style: .plain,
                                                                       target: self, action: nil)
        logoutButton.tintColor = .systemRed
        return logoutButton
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoadSubject.send()
        setupView()
        bind()
    }
    
    private func bind() {
        guard let viewModel = viewModel as? ProfileViewModel else { return }
        
        logoutButton.publisher()
            .subscribe(viewModel.logoutButtonSubject)
            .store(in: cancelBag)
        
        viewModel.$email
            .assign(to: \.text, on: emailLabel)
            .store(in: cancelBag)
        
        viewModel.$username
            .assign(to: \.text, on: usernameLabel)
            .store(in: cancelBag)
        
        viewModel.loadingPublisher.sink(receiveValue: { [weak self] isLoading in
            isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        })
        .store(in: cancelBag)
    }
    
    // MARK: - Helpers
    static func newInstanse(viewModel: ProfileViewModelType) -> ProfileViewController {
        let moreVC = StoryboardScene.Profile.profileViewController.instantiate()
        moreVC.viewModel = viewModel
        return moreVC
    }
    
    private func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.Main.TabBar.Profile.title
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    // MARK: - Deinit
    deinit {
        cancelBag.cancel()
    }
}
