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
    private var cancelBag = CancelBag()
    
    // MARK: - Input
    let doneButtonSubject = PassthroughSubject<Void, Never>()
    
    func didPressedButton(with sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.setImage(UIImage(systemName: "circle.fill"), for: .selected)
        } else {
            sender.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
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
}
