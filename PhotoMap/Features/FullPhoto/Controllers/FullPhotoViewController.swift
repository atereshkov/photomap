//
//  FullPhotoViewController.swift
//  PhotoMap
//
//  Created by yurykasper on 21.06.21.
//

import Combine
import UIKit

class FullPhotoViewController: BaseViewController {
    // MARK: - Variables
    var viewModel: FullPhotoViewModelType?
    private let cancelBag = CancelBag()
    
    // MARK: - @IBOutlet
    @IBOutlet weak var markerImage: UIImageView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.viewDidDisappear.send()
    }
    
    // MARK: - Helpers
    static func newInstance(viewModel: FullPhotoViewModelType) -> FullPhotoViewController {
        let fullPhotoVC = StoryboardScene.FullPhoto.fullPhotoViewController.instantiate()
        fullPhotoVC.viewModel = viewModel
        return fullPhotoVC
    }
    
    private func setupView() {
//        setOpacityBackgroundNavigationBar()
        bind()
    }
    
    private func bind() {
        guard let viewModel = viewModel as? FullPhotoViewModel else { return }
        guard let navBar = navigationController?.navigationBar else { return }
        
        viewModel.$image
            .assign(to: \.image, on: markerImage)
            .store(in: cancelBag)
        
        viewModel.$description
            .assign(to: \.text, on: descriptionLabel)
            .store(in: cancelBag)
        
        viewModel.$date
            .assign(to: \.text, on: dateLabel)
            .store(in: cancelBag)
        
        viewModel.$showNavbar
            .assign(to: \.isHidden, on: navBar)
            .store(in: cancelBag)
        
        viewModel.$showFooterView
            .assign(to: \.isHidden, on: footerView)
            .store(in: cancelBag)
        
        markerImage.gesture(.tap())
            .subscribe(viewModel.imageTappedSubject)
            .store(in: cancelBag)
    }
}
