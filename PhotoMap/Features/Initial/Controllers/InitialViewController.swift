//
//  InitialViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 3.05.21.
//

import UIKit

class InitialViewController: BaseViewController {
   
    static func newInstanse() -> InitialViewController {
        let initialVC = StoryboardScene.Initial.initialViewController.instantiate()
        initialVC.modalPresentationStyle = .overFullScreen
        
        return initialVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setOpacityBackgroundNavigationBar()
        activityIndicator.startAnimating()
    }
}
