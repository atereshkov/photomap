//
//  TimelineViewModel.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit
import Combine

class TimelineViewModel: TimelineViewModelType {    
    
    // MARK: - Variables
    private let coordinator: TimelineCoordinator
    private let firebaseService: FirebaseServiceType
    private var markers = [String: [Marker]]()
    private let cancelBag = CancelBag()
    private lazy var headerTitles = [String]()
    
    var numberOfSections: Int {
        return markers.count
    }
    
    // MARK: - Lifecycle
    init(coordinator: TimelineCoordinator, diContainer: DIContainerType) {
        self.coordinator = coordinator
        self.firebaseService = diContainer.resolve()
    }
    
    // MARK: - Input
    func viewDidLoad() {
        getUserMarkers()
    }
    
    // MARK: - Output
    var reloadDataSubject = PassthroughSubject<Void, Never>()
    
    func getMarker(at indexPath: IndexPath) -> Marker? {
        guard let key = headerTitles[at: indexPath.section] else { return nil }
        guard let markers = markers[key] else { return nil }
        return markers[at: indexPath.row]
    }
    
    func getTitle(for section: Int) -> String? {
        return headerTitles[at: section]
    }
    
    func getNumberOfRows(in section: Int) -> Int {
        guard let key = headerTitles[at: section] else { return 0 }
        guard let markers = markers[key] else { return 0 }
        return markers.count
    }
    
    // MARK: - Helpers
    private func getUserMarkers() {
        firebaseService.getUserMarkers()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.description)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] markers in
                self?.configureDataSource(with: markers)
                self?.reloadDataSubject.send()
            })
            .store(in: cancelBag)
    }
    
    private func configureDataSource(with markers: [Marker]) {
        guard !markers.isEmpty else { return }
        var groupedMarkers = [String: [Marker]]()
        
        for marker in markers {
            if let marks = groupedMarkers[marker.date.monthAndYear],
               marks.first?.date.monthAndYear == marker.date.monthAndYear {
                groupedMarkers[marker.date.monthAndYear] = marks + [marker]
            } else {
                groupedMarkers[marker.date.monthAndYear] = [marker]
            }
        }
        self.markers = groupedMarkers
        self.headerTitles = [String](groupedMarkers.keys)
            .sorted { (first, next) -> Bool in first.toMonthAndYearDate > next.toMonthAndYearDate }
    }
    
}
