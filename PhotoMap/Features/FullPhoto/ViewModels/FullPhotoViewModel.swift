//
//  FullPhotoViewModel.swift
//  PhotoMap
//
//  Created by yurykasper on 21.06.21.
//

import Combine
import UIKit

final class FullPhotoViewModel: FullPhotoViewModelType {
    // MARK: - Variables
    private let coordinator: FullPhotoCoordinator
    private let firestoreService: FirestoreServiceType
    private let cancelBag = CancelBag()
    
    // MARK: - Lifecycle
    init(coordinator: FullPhotoCoordinator, diContainer: DIContainerType, marker: Marker) {
        self.coordinator = coordinator
        self.firestoreService = diContainer.resolve()
        setupView(with: marker)
        transform()
    }
    
    private func transform() {
        imageTappedSubject.sink(receiveValue: { [weak self] _ in
            self?.showFooterView.toggle()
            self?.showNavbar.toggle()
        })
        .store(in: cancelBag)
        
        viewDidDisappear
            .subscribe(coordinator.viewDidDisappearSubject)
            .store(in: cancelBag)
    }
    
    // MARK: - Inputs
    let viewDidDisappear = PassthroughSubject<Void, Never>()
    let imageTappedSubject = PassthroughSubject<GestureType, Never>()
    let imageDoubleTappedSubject = PassthroughSubject<GestureType, Never>()
    
    // MARK: - Outputs
    @Published var image: UIImage?
    @Published var description: String?
    @Published var date: String?
    @Published var showFooterView = false
    @Published var showNavbar = false
    
    // MARK: - Helpers
    private func setupView(with marker: Marker) {
        description = marker.description
        date = marker.date.toString
        getImage(for: marker)
    }
    
    private func getImage(for marker: Marker) {
        guard let imageLink = marker.images.first else { return }
        let imageURL = URL(string: imageLink)
        firestoreService.downloadImage(with: imageURL).sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                self?.image = UIImage(systemName: "photo")
            }
        }, receiveValue: { [weak self] image in
            self?.image = image
        })
        .store(in: cancelBag)
    }
}
