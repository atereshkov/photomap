//
//  MapPhotoViewModel.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6.05.21.
//

import UIKit
import Combine

class MapPhotoViewModel: NSObject, MapPhotoViewModelType {
    // MARK: - Variables
    private var cancellables = Set<AnyCancellable>()
    private let coordinator: MapPhotoCoordinator
    private let diContainer: DIContainerType
    private let firestoreService: FirestoreServiceType
    private var categories = [Category]()
    private let activityIndicator = ActivityIndicator()
    // MARK: - Computed Variables
    private var isDisabledCategoryPicker: Bool {
        categories.isEmpty
    }

    // MARK: - Input
    private(set) var cancelButtonSubject = PassthroughSubject<UIControl, Never>()
    private(set) var descriptionSubject = PassthroughSubject<String, Never>()
    private(set) var doneButtonSubject = PassthroughSubject<String, Never>()
    private(set) var categoryViewSubject = PassthroughSubject<GestureType, Never>()
    private(set) var closeBarButtonSubject = PassthroughSubject<Bool, Never>()
    private(set) var loadCategoriesSubject = PassthroughSubject<Void, Never>()

    // MARK: - Output
    @Published private(set) var isHiddenCategoryPicker: Bool = true
    @Published private(set) var categoryPublisher: Category?
    @Published private(set) var photoPublisher: PhotoDVO
    var loadingPublisher: AnyPublisher<Bool, Never> {
        activityIndicator.loading
    }

    // MARK: - Initialize
    init(coordinator: MapPhotoCoordinator, diContainer: DIContainerType, photo: PhotoDVO) {
        self.coordinator = coordinator
        self.diContainer = diContainer
        self.firestoreService = diContainer.resolve()
        self.photoPublisher = photo

        super.init()

        transform()
    }

    private func transform() {
        cancelButtonSubject
            .map { _ in }
            .subscribe(coordinator.prepareForDismissSubject)
            .store(in: &cancellables)

        $categoryPublisher
            .sink { [weak self] category in self?.photoPublisher.category = category }
            .store(in: &cancellables)

        doneButtonSubject
            .sink { [weak self] description in
                self?.saveNewPhoto(with: description)
            }
            .store(in: &cancellables)

        firestoreService.getCategories()
            .sink(receiveCompletion: сompletionHandler,
                  receiveValue: { [weak self] categories in
                self?.categories = categories
                self?.categoryPublisher = categories[safe: 0]
                self?.loadCategoriesSubject.send()
            })
            .store(in: &cancellables)

        categoryViewSubject
            .sink { [weak self] _ in self?.isHiddenCategoryPicker = !(self?.isHiddenCategoryPicker ?? false) }
            .store(in: &cancellables)

        closeBarButtonSubject
            .sink(receiveValue: { [weak self] isHidden in self?.isHiddenCategoryPicker = isHidden })
            .store(in: &cancellables)
    }

    // MARK: - Utils
    private func saveNewPhoto(with description: String) {
        photoPublisher.description = description

        firestoreService.addUserPhoto(with: UploadPhoto(from: photoPublisher))
            .trackActivity(activityIndicator)
            .sink(receiveCompletion: сompletionHandler,
                  receiveValue: { [weak self] _ in
                self?.coordinator.prepareForDismissSubject.send()
            })
            .store(in: &cancellables)
    }

    private func сompletionHandler(_ completion: Subscribers.Completion<FirestoreError>) {
        switch completion {
        case .failure(let error):
            coordinator.errorAlertSubject.send(error)
        case .finished:
            return
        }
    }
    
    // MARK: - deinit
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

// MARK: - UIPickerViewDelegate
extension MapPhotoViewModel: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryPublisher = categories[safe: row]
    }
}

// MARK: - UIPickerViewDataSource
extension MapPhotoViewModel: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        categories[safe: row]?.name
    }
}
