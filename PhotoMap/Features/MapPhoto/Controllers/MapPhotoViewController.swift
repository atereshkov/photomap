//
//  MapPhotoViewController.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6.05.21.
//

import UIKit
import Combine

class MapPhotoViewController: BaseViewController {
    // MARK: - Variables
    private var viewModel: MapPhotoViewModel?
    private let cancelBag = CancelBag()

    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var categoryView: CategoryView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var categoryPckerView: UIPickerView!
    
    static func newInstanse(viewModel: MapPhotoViewModel) -> MapPhotoViewController {
        let mapVC = StoryboardScene.MapPhoto.mapPhotoViewController.instantiate()
        mapVC.viewModel = viewModel

        return mapVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        categoryPckerView.delegate = viewModel
        categoryPckerView.dataSource = viewModel

        setOpacityBackgroundNavigationBar()
        bind()
    }

    private func bind() {
        guard let viewModel = viewModel else { return }

        viewModel.$isHiddenCategoryPicker
            .assign(to: \.isHidden, on: categoryPckerView)
            .store(in: cancelBag)

        cancelButton.tapPublisher
            .map { _ in () }
            .assign(to: \.cancelPublisher, on: viewModel)
            .store(in: cancelBag)
        categoryView.gesture(.tap())
            .map { _ in () }
            .assign(to: \.categoryPublisher, on: viewModel)
            .store(in: cancelBag)
    }
}
