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
    private let coordinator: CategoryCoordinator
    private let firestoreService: FirestoreServiceType
    private var categories = [Category]()
    private let cancelBag = CancelBag()
    private let activityIndicator = ActivityIndicator()
    
    // MARK: - Lifecycle
    init(coordinator: CategoryCoordinator, diContainer: DIContainerType) {
        self.coordinator = coordinator
        self.firestoreService = diContainer.resolve()
        transform()
    }
    
    private func transform() {
        firestoreService.getCategories()
            .receive(on: DispatchQueue.main)
            .trackActivity(activityIndicator)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.showErrorAlertSubject.send(error)
                }
            }, receiveValue: { [weak self] categories in
                self?.categories = categories
                self?.categoriesSubject.send(categories)
                self?.reloadDataSubject.send()
            })
            .store(in: cancelBag)

        doneButtonSubject
            .map { [weak self] _ -> [Category] in self?.categories.filter { $0.isSelected } ?? [] }
            .subscribe(coordinator.categoriesSubject)
            .store(in: cancelBag)

        doneButtonSubject
            .map { _ in ()}
            .subscribe(coordinator.prepareForDismissSubject)
            .store(in: cancelBag)
        
        showErrorAlertSubject
            .subscribe(coordinator.showErrorAlertSubject)
            .store(in: cancelBag)
    }
    
    // MARK: - Input
    let doneButtonSubject = PassthroughSubject<UIBarButtonItem, Never>()
    let showErrorAlertSubject = PassthroughSubject<GeneralErrorType, Never>()
    
    func didSelectRow(at indexPath: IndexPath) {
        guard var category = categories[at: indexPath.row] else { return }
        categories.remove(at: indexPath.row)
        category.isSelected = !category.isSelected
        categories.insert(category, at: indexPath.row)
        doneButtonIsEnabled.send(!categories.filter { $0.isSelected }.isEmpty)
        categoriesSubject.send(categories)
        reloadDataSubject.send()
    }
    
    // MARK: - Output
    let doneButtonIsEnabled = CurrentValueSubject<Bool, Never>(true)
    let reloadDataSubject = PassthroughSubject<Void, Never>()
    let categoriesSubject = CurrentValueSubject<[Category], Never>([])
    
    var loadingPublisher: AnyPublisher<Bool, Never> {
        return activityIndicator.loading.eraseToAnyPublisher()
    }
    
    func getNumberOfRows() -> Int {
        return categories.count
    }
    
    func getCategory(at indexPath: IndexPath) -> Category? {
        return categories[at: indexPath.row]
    }
    
    // MARK: - deinit
    deinit {
        cancelBag.cancel()
    }
}
