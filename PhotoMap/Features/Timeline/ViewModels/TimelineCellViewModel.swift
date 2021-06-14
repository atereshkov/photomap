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
    init(firestoreService: FirestoreServiceType) {
        self.firestoreService = firestoreService
    }
    
    // MARK: - Input
    private let activityIndicator = ActivityIndicator()
    
    // MARK: - Output
    var loadingPublisher: AnyPublisher<Bool, Never> {
        return activityIndicator.loading.eraseToAnyPublisher()
    }
    
    let urlSubject = PassthroughSubject<URL?, Never>()
    
    // MARK: - Helpers
    func downloadImage(for marker: Marker) {
        firestoreService.downloadImage(for: marker)
            .trackActivity(activityIndicator)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self?.urlSubject.send(nil)
                }
            }, receiveValue: { [weak self] url in
                self?.urlSubject.send(url)
            })
            .store(in: cancelBag)
    }
}
