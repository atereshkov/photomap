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
    private var isShowKeyboard = false
    private var bottomConstraintConstant: CGFloat = 0

    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var categoryView: CategoryView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var categoryPickerView: UIPickerView!
    @IBOutlet private weak var pickerToolBar: UIToolbar!
    @IBOutlet private weak var closeBarButton: UIBarButtonItem!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    static func newInstanse(viewModel: MapPhotoViewModel) -> MapPhotoViewController {
        let mapVC = StoryboardScene.MapPhoto.mapPhotoViewController.instantiate()
        mapVC.viewModel = viewModel

        return mapVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setOpacityBackgroundNavigationBar()
        setupUI()

        bind()
        bindActions()

        bottomConstraintConstant = contentViewBottomConstraint.constant
    }

    private func bind() {
        guard let viewModel = viewModel else { return }

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink(receiveValue: { [weak self] notification in self?.keybordWillShow(notification) })
            .store(in: cancelBag)
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink(receiveValue: { [weak self] notification in self?.keybordWillHide(notification) })
            .store(in: cancelBag)

        viewModel.$photoPublisher
            .sink(receiveValue: { [weak self] photo in
                self?.imageView.image = photo.image
                self?.dateLabel.text = photo.date.toString
                self?.descriptionTextView.text = photo.description
            })
            .store(in: cancelBag)

        viewModel.$isHiddenCategoryPicker
            .sink(receiveValue: { [weak self] isHidden in
                self?.categoryPickerView.isHidden = isHidden
                self?.pickerToolBar.isHidden = isHidden
            })
            .store(in: cancelBag)

        viewModel.$categoryPublisher
            .filter { $0 != nil }
            .subscribe(categoryView.categorySubject)
            .store(in: cancelBag)

        viewModel.loadCategoriesSubject
            .sink { [weak self] _ in self?.categoryPickerView.reloadAllComponents() }
            .store(in: cancelBag)

        viewModel.loadingPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isLoading in
                self?.view.isUserInteractionEnabled = !isLoading
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            })
            .store(in: cancelBag)
    }

    private func bindActions() {
        guard let viewModel = viewModel else { return }

        categoryView.gesture(.tap())
            .subscribe(viewModel.categoryViewSubject)
            .store(in: cancelBag)

        closeBarButton.publisher
            .map { _ in true }
            .subscribe(viewModel.closeBarButtonSubject)
            .store(in: cancelBag)

        viewModel.$categoryPublisher
            .map { $0 != nil }
            .sink(receiveValue: { [weak self] isEnable in
                self?.doneButton.isEnabled = isEnable
            })
            .store(in: cancelBag)

        viewModel.loadingPublisher
            .map { !$0 }
            .sink(receiveValue: { [weak self] isEnable in
                self?.doneButton.isEnabled = isEnable
            })
            .store(in: cancelBag)

        doneButton.tapPublisher
            .map { [weak self] _ in self?.descriptionTextView.text ?? "" }
            .subscribe(viewModel.doneButtonSubject)
            .store(in: cancelBag)
        
        cancelButton.tapPublisher
            .subscribe(viewModel.cancelButtonSubject)
            .store(in: cancelBag)
        
        // Hide keyboard when tap on view
        view.gesture(.tap())
            .filter { [weak self] _ in self?.isShowKeyboard ?? false }
            .sink(receiveValue: { [weak self] _ in self?.view.endEditing(true) })
            .store(in: cancelBag)
    }

    private func setupUI() {
        doneButton.setTitle(L10n.Main.MapPhoto.Button.Title.done, for: .application)
        cancelButton.setTitle(L10n.Main.MapPhoto.Button.Title.cancel, for: .application)
        closeBarButton.title = L10n.Main.MapPhoto.Button.Title.close

        categoryPickerView.delegate = viewModel
        categoryPickerView.dataSource = viewModel

        pickerToolBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    // MARK: - deinit
    deinit {
        print(" - deinit - MapPhotoViewController")

        categoryPickerView.delegate = nil
        categoryPickerView.dataSource = nil
        viewModel = nil
//        categoryView = nil
        cancelBag.cancel()
    }
}

// MARK: - Keyboard notifications
extension MapPhotoViewController {
    private func keybordWillShow(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo,
              let keyboardNSValue: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        var keyboardFrame: CGRect = keyboardNSValue.cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        isShowKeyboard = true
        
        self.contentViewBottomConstraint.constant = keyboardFrame.size.height
    }
    
    private func keybordWillHide(_ notification: Notification) {
        isShowKeyboard = false
        self.contentViewBottomConstraint.constant = bottomConstraintConstant
    }
}
