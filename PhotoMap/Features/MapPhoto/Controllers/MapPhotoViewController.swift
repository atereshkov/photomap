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
    @IBOutlet private weak var pickerToolBar: UIToolbar!
    @IBOutlet private weak var closeBarButton: UIBarButtonItem!
    
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
        setupToolBar()

        bind()
        bindActions()
    }

    private func bind() {
        guard let viewModel = viewModel else { return }

        viewModel.$photoPublisher
            .map { $0.image }
            .assign(to: \.image, on: imageView)
            .store(in: cancelBag)
        viewModel.$photoPublisher
            .map { $0.date.toString }
            .assign(to: \.text, on: dateLabel)
            .store(in: cancelBag)
        viewModel.$photoPublisher
            .map { $0.description }
            .assign(to: \.text, on: descriptionTextView)
            .store(in: cancelBag)
        viewModel.$isHiddenCategoryPicker
            .assign(to: \.isHidden, on: categoryPckerView)
            .store(in: cancelBag)
        viewModel.$isHiddenCategoryPicker
            .assign(to: \.isHidden, on: pickerToolBar)
            .store(in: cancelBag)
        viewModel.$categoryPublisher
            .filter { $0 != nil }
            .subscribe(categoryView.categorySubject)
            .store(in: cancelBag)
        viewModel.$closeCategoryPickerViewButtonTitle
            .assign(to: \.title, on: closeBarButton)
            .store(in: cancelBag)
        viewModel.$doneButtonTitle
            .sink(receiveValue: { [weak self] title in
                self?.doneButton.setTitle(title, for: .application)
            })
            .store(in: cancelBag)
        viewModel.$cancelButtonTitle
            .sink(receiveValue: { [weak self] title in
                self?.cancelButton.setTitle(title, for: .application)
            })
            .store(in: cancelBag)
    }

    private func bindActions() {
        guard let viewModel = viewModel else { return }

        categoryView.gesture(.tap())
            .subscribe(viewModel.categoryViewSubject)
            .store(in: cancelBag)

        closeBarButton.publisher
            .subscribe(viewModel.closeBarButtonSubject)
            .store(in: cancelBag)

        doneButton.tapPublisher
            .subscribe(viewModel.doneButtonSubject)
            .store(in: cancelBag)
        cancelButton.tapPublisher
            .subscribe(viewModel.cancelButtonSubject)
            .store(in: cancelBag)
    }

    private func setupToolBar() {
        pickerToolBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
