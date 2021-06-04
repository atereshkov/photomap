//
//  BaseViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.backgroundColor = Asset.activityIndicatorBackgroundColor.color
        activityIndicator.center = view.center
        activityIndicator.style = .large
        activityIndicator.tag = 1
        activityIndicator.color = Asset.activityIndicatorIndicatorColor.color
        activityIndicator.layer.zPosition = -1

        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(activityIndicator)
    }
    
    func setOpacityBackgroundNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupNavigationBar(isLargeTitle: Bool = true) {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Asset.baseVCAppearanceBackgroundColor.color
        appearance.titleTextAttributes = [.foregroundColor: Asset.baseVCAppearanceTitleTextAttributes.color]
        appearance.largeTitleTextAttributes = [.foregroundColor: Asset.baseVCAppearanceLargeTitleTextAttributes.color]
        
        navigationController?.navigationBar.tintColor = Asset.navBarTintColor.color
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
}
