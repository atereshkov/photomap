//
//  MapPhotoViewModel.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6.05.21.
//

import UIKit
import Combine

class MapPhotoViewModel: NSObject {
    // MARK: - Variables
    private let cancelBag = CancelBag()
    private let coordinator: MapPhotoCoordinator
    private let diContainer: DIContainerType
    private var categories: [String] = ["DEFAULT", "FRIENDS", "NATURE"]

    // MARK: - Input
    @Published var cancelPublisher: Void?
    @Published var categoryPublisher: Void = ()

    // MARK: - Output
    @Published var isHiddenCategoryPicker: Bool = true

    var descriptionSubject = PassthroughSubject<String, Never>()
    var doneButtonSubject = PassthroughSubject<Void, Never>()

    init(coordinator: MapPhotoCoordinator,
         diContainer: DIContainerType) {
        self.coordinator = coordinator
        self.diContainer = diContainer
        super.init()

        transform()
    }

    private func transform() {
        $cancelPublisher
            .filter { $0 != nil }
            .assign(to: \.dismissPublisher, on: coordinator)
            .store(in: cancelBag)

        $categoryPublisher
            .dropFirst()
            .map { _ in false }
            .assign(to: \.isHiddenCategoryPicker, on: self)
            .store(in: cancelBag)
    }
}

extension MapPhotoViewModel: UIPickerViewDelegate {}

extension MapPhotoViewModel: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        3
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        categories[row]
    }
}
