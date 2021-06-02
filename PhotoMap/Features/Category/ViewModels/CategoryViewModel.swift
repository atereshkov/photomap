//
//  CategoryViewModel.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import Combine
import UIKit

class CategoryViewModel: CategoryViewModelType {
    
    // MARK: - Variables
    private var coordinator: CategoryCoordinator
    private var categories = [
        Category(id: "0", name: "DEFAULT", color: "#368EDF"),
        Category(id: "1", name: "FRIENDS", color: "#F4A523"),
        Category(id: "2", name: "NATURE", color: "#578E18")
    ]
    private var cancelBag = CancelBag()
    
    // MARK: - Lifecycle
    init(coordinator: CategoryCoordinator, diContainer: DIContainerType) {
        self.coordinator = coordinator
        transform()
    }
    
    private func transform() {
        doneButtonSubject.sink(receiveValue: { [weak self] in
            self?.coordinator.doneButtonPressed()
        })
        .store(in: cancelBag)
    }
    
    // MARK: - Input
    let doneButtonSubject = PassthroughSubject<Void, Never>()
    
    func didSelectCell(at indexPath: IndexPath) {
        guard var category = categories[at: indexPath.row] else { return }
        categories.remove(at: indexPath.row)
        category.isSelected = !category.isSelected
        categories.insert(category, at: indexPath.row)
        reloadDataSubject.send()
    }
    
    // MARK: - Output
    let reloadDataSubject = PassthroughSubject<Void, Never>()
    
    func getNumberOfRows() -> Int {
        return categories.count
    }
    
    func getCategory(at indexPath: IndexPath) -> Category? {
        return categories[at: indexPath.row]
    }
}
