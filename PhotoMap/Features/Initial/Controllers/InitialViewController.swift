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
        
        self.viewModel?.viewDidLoad()
        self.viewModel?.viewWillDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.viewModel?.viewWillDisappear()
    }

}
