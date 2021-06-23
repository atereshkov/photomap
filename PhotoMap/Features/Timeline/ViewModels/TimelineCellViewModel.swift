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
    init(firestoreService: FirestoreServiceType, marker: Marker) {
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
    private func setupCell(with marker: Marker) {
        description = marker.description
        date = marker.date.shortDate
        category = marker.category
        downloadImage(for: marker)
    }
    
    private func downloadImage(for marker: Marker) {
        guard let imageLink = marker.images.first else { return }
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
}
