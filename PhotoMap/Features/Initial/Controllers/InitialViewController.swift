//
//  InitialViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 3.05.21.
//

import UIKit

class InitialViewController: BaseViewController {
    
    private var viewModel: InitialViewModel?
   
    static func newInstanse(viewModel: InitialViewModel) -> InitialViewController {
        let initialVC = StoryboardScene.Initial.initialViewController.instantiate()
        initialVC.viewModel = viewModel
        
        return initialVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        activityIndicator.startAnimating()
        
        // Alex, 05.05.21: Remote async, just for testing purposes
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.viewModel?.viewDidLoad()
        }
    }
    
}
