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
    private var cancellables = Set<AnyCancellable>()

    private var bottomConstraintConstant: CGFloat = 0
    private var categoryPickerView = UIPickerView()

    private lazy var closeBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = L10n.Main.MapPhoto.Button.Title.close
        barButton.style = .done

        return barButton
    }()
    private lazy var pickerToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        toolBar.setItems([closeBarButton], animated: true)

        return toolBar
    }()

    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var categoryTextField: CategoryTextField!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
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
            .store(in: &cancellables)
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink(receiveValue: { [weak self] notification in self?.keybordWillHide(notification) })
            .store(in: &cancellables)

        viewModel.$photoPublisher
            .sink(receiveValue: { [weak self] photo in
                self?.imageView.image = photo.image
                self?.dateLabel.text = photo.date.toString
                self?.descriptionTextView.text = photo.description
            })
            .store(in: &cancellables)

        viewModel.$categoryPublisher
            .filter { $0 != nil }
            .sink(receiveValue: { [weak self] category in
                guard let category = category else { return }
                self?.categoryTextField.set(category)
            })
            .store(in: &cancellables)

        viewModel.loadCategoriesSubject
            .sink { [weak self] _ in self?.categoryPickerView.reloadAllComponents() }
            .store(in: &cancellables)

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
            .store(in: &cancellables)
    }

    private func bindActions() {
        guard let viewModel = viewModel else { return }

        viewModel.$categoryPublisher
            .map { $0 != nil }
            .sink(receiveValue: { [weak self] isEnable in
                self?.doneButton.isEnabled = isEnable
            })
            .store(in: &cancellables)

        doneButton.tapPublisher
            .map { [weak self] _ in self?.descriptionTextView.text ?? "" }
            .sink(receiveValue: { [weak self] text in
                    self?.view.endEditing(true)
                    viewModel.doneButtonSubject.send(text) })
//            .subscribe(viewModel.doneButtonSubject)
            .store(in: &cancellables)
        
        cancelButton.tapPublisher
            .sink(receiveValue: { control in viewModel.cancelButtonSubject.send(control) })
//            .subscribe(viewModel.cancelButtonSubject)
            .store(in: &cancellables)
        
        // Hide keyboard when tap on view
        closeBarButton.publisher()
            .sink(receiveValue: { [weak self] _ in self?.view.endEditing(true) })
            .store(in: &cancellables)
        
        view.gesture(.tap())
            .sink(receiveValue: { [weak self] _ in self?.view.endEditing(true) })
            .store(in: &cancellables)
    }

    private func setupUI() {
        doneButton.setTitle(L10n.Main.MapPhoto.Button.Title.done, for: .application)
        cancelButton.setTitle(L10n.Main.MapPhoto.Button.Title.cancel, for: .application)
        
        categoryTextField.inputView = categoryPickerView
        categoryTextField.inputAccessoryView = pickerToolBar

        categoryPickerView.delegate = viewModel
        categoryPickerView.dataSource = viewModel
    }
    
    // MARK: - deinit
    deinit {
        categoryPickerView.delegate = nil
        categoryPickerView.dataSource = nil
        viewModel = nil
        categoryTextField = nil

        cancellables.forEach { $0.cancel() }
    }
}

// MARK: - Keyboard notifications
extension MapPhotoViewController {
    private func keybordWillShow(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo,
              let keyboardNSValue: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        var keyboardFrame: CGRect = keyboardNSValue.cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        self.contentViewBottomConstraint.constant = keyboardFrame.size.height
    }
    
    private func keybordWillHide(_ notification: Notification) {
        self.contentViewBottomConstraint.constant = bottomConstraintConstant
    }
}
