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
            activityIndicator.backgroundColor = Asset.whiteColor.color
            activityIndicator.center = view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = .large
            activityIndicator.tag = 1
            activityIndicator.color = Asset.blackColor.color
            view.addSubview(activityIndicator)

        return activityIndicator
    }()

    func setOpacityBackgroundNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

    func setupNavigationBar(isLargeTitle: Bool = true) {
        navigationController?.navigationBar.prefersLargeTitles = true

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Asset.whiteColor.color
        appearance.titleTextAttributes = [.foregroundColor: Asset.blackColor.color]
        appearance.largeTitleTextAttributes = [.foregroundColor: Asset.blackColor.color]

        navigationController?.navigationBar.tintColor = Asset.blackColor.color
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
