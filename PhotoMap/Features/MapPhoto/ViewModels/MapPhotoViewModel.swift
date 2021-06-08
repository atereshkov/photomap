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
    private(set) var doneButtonSubject = PassthroughSubject<String, Never>()
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

    // MARK: - Initialize
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

        $categoryPublisher
            .sink { [weak self] category in self?.photoPublisher.category = category }
            .store(in: cancelBag)

        doneButtonSubject
            .throttle(for: .milliseconds(20), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] description in
                self?.saveNewPhoto(with: description)
            }
            .store(in: cancelBag)

        firestoreService.getCategories()
            .sink(receiveCompletion: { [weak self] completion in
                self?.completionHandler(with: completion)
            }, receiveValue: { [weak self] categories in
                guard let self = self else { return }
                self.categories = categories
                self.categoryPublisher = categories[safe: 0]
                self.loadCategoriesSubject.send()
            })
            .store(in: self.cancelBag)

        categoryViewSubject
            // It is a good case?
            .map { [unowned self] _ in self.categories.isEmpty }
            .assign(to: \.isHiddenCategoryPicker, on: self)
            .store(in: cancelBag)

        closeBarButtonSubject
            .map { _ in true }
            .assign(to: \.isHiddenCategoryPicker, on: self)
            .store(in: cancelBag)
    }

    // MARK: - Utils
    private func completionHandler(with completion: Subscribers.Completion<FirestoreError>) {
        switch completion {
        case .failure(let error):
            coordinator.errorAlertSubject.send(error)
        case .finished:
            return
        }
    }

    private func saveNewPhoto(with description: String) {
        guard let data = photoPublisher.image.pngData() else {
            coordinator.errorAlertSubject.send(.custom("Image error"))
            return
        }
        photoPublisher.description = description

        firestoreService.uploadPhoto(data)
            .receive(on: DispatchQueue.main)
            .trackActivity(activityIndicator)
            .flatMap { [unowned self] url in
                self.firestoreService.addUserMarker(with: self.photoPublisher.toDictionary(urls: [url.absoluteString]))
            }
            .sink(receiveCompletion: { [weak self] completion in
                self?.completionHandler(with: completion)
            }, receiveValue: { [weak self] _ in
                self?.coordinator.dismissSubject.send(UIControl())
            })
            .store(in: cancelBag)
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
