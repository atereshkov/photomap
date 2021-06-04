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
    private let cancelBag = CancelBag()
    private let coordinator: MapPhotoCoordinator
    private let diContainer: DIContainerType
    private let firestoreService: FirestoreServiceType
    private var categories = [Category]()
    private let activityIndicator = ActivityIndicator()

    // MARK: - Input
    private(set) var cancelButtonSubject = PassthroughSubject<UIControl, Never>()
    private(set) var descriptionSubject = PassthroughSubject<String, Never>()
    private(set) var doneButtonSubject = PassthroughSubject<UIControl, Never>()
    private(set) var categoryViewSubject = PassthroughSubject<GestureType, Never>()
    private(set) var closeBarButtonSubject = PassthroughSubject<UIBarButtonItem, Never>()
    private(set) var loadCategoriesSubject = PassthroughSubject<Void, Never>()

    // MARK: - Output
    @Published private(set) var isHiddenCategoryPicker: Bool = true
    @Published private(set) var categoryPublisher: Category?
    @Published private(set) var photoPublisher: Photo
    var loadingPublisher: AnyPublisher<Bool, Never> {
        activityIndicator.loading
    }

    init(coordinator: MapPhotoCoordinator, diContainer: DIContainerType, photo: Photo) {
        self.coordinator = coordinator
        self.diContainer = diContainer
        self.firestoreService = diContainer.resolve()
        self.photoPublisher = photo
        super.init()

        transform()
    }

    private func transform() {
        cancelButtonSubject
            .subscribe(coordinator.dismissSubject)
            .store(in: cancelBag)

        doneButtonSubject
            .trackActivity(activityIndicator)
            .sink { [weak self] control in
                guard let self = self else { return }
                // Save new PhotoMap object in Firebase and close screen
                self.coordinator.dismissSubject.send(control)
            }
            .store(in: cancelBag)

        firestoreService.getCategories()
            .trackActivity(activityIndicator)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { [weak self] categories in
                guard let self = self else { return }
                print(categories)
                self.categories = categories
                self.categoryPublisher = categories[safe: 0]
                self.loadCategoriesSubject.send()
            })
            .store(in: self.cancelBag)

        categoryViewSubject
            .map { _ in false }
            .assign(to: \.isHiddenCategoryPicker, on: self)
            .store(in: cancelBag)

        closeBarButtonSubject
            .map { _ in true }
            .assign(to: \.isHiddenCategoryPicker, on: self)
            .store(in: cancelBag)
    }
}

extension MapPhotoViewModel: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryPublisher = categories[safe: row]
    }
}

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
