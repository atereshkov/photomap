//
//  TimelineCellViewModel.swift
//  PhotoMap
//
//  Created by yurykasper on 14.06.21.
//

import Combine
import UIKit

final class TimelineCellViewModel {
    // MARK: - Variables
    private let firestoreService: FirestoreServiceType
    private let cancelBag = CancelBag()
    
    // MARK: - Lifecycle
    init(firestoreService: FirestoreServiceType, marker: PhotoDVO) {
        self.firestoreService = firestoreService
        setupCell(with: marker)
    }
    
    // MARK: - Input
    private let activityIndicator = ActivityIndicator()
    
    // MARK: - Output
    @Published var description: String?
    @Published var date: String?
    @Published var category: String?
    @Published var image: UIImage?
    
    var loadingPublisher: AnyPublisher<Bool, Never> {
        return activityIndicator.loading.eraseToAnyPublisher()
    }
    
    // MARK: - Helpers
    private func setupCell(with marker: PhotoDVO) {
        description = marker.description
        date = marker.date.shortDate
        category = marker.category?.name
        downloadImage(for: marker)
    }
    
    private func downloadImage(for marker: PhotoDVO) {
        guard let imageLink = marker.imageUrls.first else { return }
        let downloadURL = URL(string: imageLink)
        firestoreService.downloadImage(with: downloadURL)
            .trackActivity(activityIndicator)
            .sink(receiveCompletion: { [weak self] completion in
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

    // MARK: - deinit
    deinit {
        cancelBag.cancel()
    }
}
