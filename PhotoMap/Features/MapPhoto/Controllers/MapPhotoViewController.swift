//
//  MapPhotoViewController.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6.05.21.
//

import UIKit

class MapPhotoViewController: BaseViewController {
    // MARK: - Variables
    private var viewModel: MapPhotoViewModel?
    private let cancelBag = CancelBag()

    static func newInstanse(viewModel: MapPhotoViewModel) -> MapPhotoViewController {
        let mapVC = StoryboardScene.MapPhoto.mapPhotoViewController.instantiate()
        mapVC.viewModel = viewModel

        return mapVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
