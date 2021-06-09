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
    
    // MARK: - Lifecycle
    init(coordinator: CategoryCoordinator, diContainer: DIContainerType) {
        self.coordinator = coordinator
        self.firestoreService = diContainer.resolve()
        transform()
    }
    
    private func transform() {
        doneButtonSubject.sink(receiveValue: { [weak self] _ in
            self?.coordinator.doneButtonSubject.send()
        })
        .store(in: cancelBag)
        
        showErrorAlertSubject
            .subscribe(coordinator.showErrorAlertSubject)
            .store(in: cancelBag)
        
        viewDidLoadSubject.sink(receiveValue: { [weak self] in
            self?.getCategories()
        })
        .store(in: cancelBag)
    }
    
    // MARK: - Input
    let doneButtonSubject = PassthroughSubject<UIBarButtonItem, Never>()
    let showErrorAlertSubject = PassthroughSubject<GeneralErrorType, Never>()
    let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private let activityIndicator = ActivityIndicator()
    
    private func getCategories() {
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
                self?.reloadDataSubject.send()
            })
            .store(in: cancelBag)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard var category = categories[at: indexPath.row] else { return }
        categories.remove(at: indexPath.row)
        category.isSelected = !category.isSelected
        categories.insert(category, at: indexPath.row)
        reloadDataSubject.send()
    }
    
    // MARK: - Output
    let reloadDataSubject = PassthroughSubject<Void, Never>()
    
    var loadingPublisher: AnyPublisher<Bool, Never> {
        return activityIndicator.loading.eraseToAnyPublisher()
    }
    
    func getNumberOfRows() -> Int {
        return categories.count
    }
    
    func getCategory(at indexPath: IndexPath) -> Category? {
        return categories[at: indexPath.row]
    }
}
