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
    private var categories: [Category] = [Category(id: "0", name: "DEFAULT", color: "#368EDF"),
                                            Category(id: "1", name: "FRIENDS", color: "#F4A523"),
                                            Category(id: "2", name: "NATURE", color: "#578E18")]

    // MARK: - Input
    private(set) var cancelButtonSubject = PassthroughSubject<UIControl, Never>()
    private(set) var descriptionSubject = PassthroughSubject<String, Never>()
    private(set) var doneButtonSubject = PassthroughSubject<UIControl, Never>()

    // MARK: - Output
    @Published var isHiddenCategoryPicker: Bool = true
    @Published private(set) var categoryPublisher: Category?

    init(coordinator: MapPhotoCoordinator, diContainer: DIContainerType) {
        self.coordinator = coordinator
        self.diContainer = diContainer
        super.init()

        transform()
    }

    private func transform() {
        cancelButtonSubject
            .subscribe(coordinator.dismissSubject)
            .store(in: cancelBag)

        doneButtonSubject
            .sink { [weak self] control in
                // Save new PhotoMap object in Firebase and close screen
                self?.coordinator.dismissSubject.send(control)
            }
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
