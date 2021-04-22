//
//  BaseViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import UIKit

class BaseViewController: UIViewController, Storyboarded {
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
            activityIndicator.backgroundColor = UIColor(named: "white")
            activityIndicator.center = view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = .large
            activityIndicator.tag = 1
            activityIndicator.color = UIColor(named: "black")
            view.addSubview(activityIndicator)

        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setOpacityBackgroundNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

    func setupNavigationBar(isLargeTitle: Bool = true) {
        navigationController?.navigationBar.prefersLargeTitles = true

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "white")
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "black")]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "black")]

        navigationController?.navigationBar.tintColor = UIColor(named: "black")
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
