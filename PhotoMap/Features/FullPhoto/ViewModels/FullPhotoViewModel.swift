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
    private weak var coordinator: FullPhotoCoordinator!
    private let firestoreService: FirestoreServiceType
    private let cancelBag = CancelBag()
    
    // MARK: - Lifecycle
    init(coordinator: FullPhotoCoordinator, diContainer: DIContainerType, marker: PhotoDVO) {
        self.coordinator = coordinator
        self.firestoreService = diContainer.resolve()
        setupView(with: marker)
        transform()
    }
    
    private func transform() {
        imageTappedSubject.sink(receiveValue: { [weak self] _ in
            self?.footerAndNavBarHidden.toggle()
        })
        .store(in: cancelBag)
        
        viewDidDisappearSubject
            .subscribe(coordinator.dismissSubject)
            .store(in: cancelBag)
    }
    
    // MARK: - Inputs
    let viewDidDisappearSubject = PassthroughSubject<Void, Never>()
    let imageTappedSubject = PassthroughSubject<GestureType, Never>()
    
    // MARK: - Outputs
    @Published var image: UIImage?
    @Published var description: String?
    @Published var date: String?
    @Published var footerAndNavBarHidden = false
    
    // MARK: - Helpers
    private func setupView(with marker: PhotoDVO) {
        description = marker.description
        date = marker.date.toString
        getImage(for: marker)
    }
    
    private func getImage(for marker: PhotoDVO) {
        guard let imageLink = marker.imageUrls.first else { return }
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

    deinit {
        cancelBag.cancel()
    }
}
