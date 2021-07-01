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
    private weak var coordinator: TimelineCoordinator!
    private let firestoreService: FirestoreServiceType
    private var allMarkers = [String: [PhotoDVO]]()
    private(set) var categorizedMarkers = [String: [PhotoDVO]]()
    private(set) var headerTitles = [String]()
    private var searchingMarkers = [String: [PhotoDVO]]()
    private var searchingHeaderTitles = [String]()
    private let cancelBag = CancelBag()
    
    // MARK: - Lifecycle
    init(coordinator: TimelineCoordinator, diContainer: DIContainerType) {
        self.coordinator = coordinator
        self.firestoreService = diContainer.resolve()
        transform()
    }
    
    private func transform() {
        searchTextSubject.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] hashtag in
                self?.searchMarkersWith(hashtag: hashtag.trim())
                self?.reloadDataSubject.send()
            })
            .store(in: cancelBag)
        
        categoryButtonSubject
            .subscribe(coordinator.categoryButtonTapped)
            .store(in: cancelBag)
        
        showErrorSubject
            .subscribe(coordinator.showErrorAlertSubject)
            .store(in: cancelBag)
        
        viewDidLoadSubject.sink(receiveValue: { [weak self] in
            self?.getUserMarkers()
        })
        .store(in: cancelBag)
        
        coordinator.doneButtonPressedWithCategoriesSubject
            .subscribe(selectedCategoriesSubject)
            .store(in: cancelBag)
        
        didSelectRowSubject.sink(receiveValue: { [weak self] indexPath in
            guard let marker = self?.getMarker(at: indexPath) else { return }
            self?.coordinator.didSelectMarkerSubject.send(marker)
        })
        .store(in: cancelBag)
        
        selectedCategoriesSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] categories in
                let categoriesTitles = categories.map { String($0.name) }
                let markers = self?.allMarkers.values
                    .flatMap { $0 }
                    .filter { categoriesTitles.contains($0.category?.name ?? "") }
                let results = self?.configureDataSource(with: markers ?? [])
                self?.categorizedMarkers = results?.markers ?? [:]
                self?.headerTitles = results?.titles ?? []
                self?.searchTextSubject.value = ""
                self?.reloadDataSubject.send()
            })
            .store(in: cancelBag)
    }
    
    // MARK: - Input
    let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    let categoryButtonSubject = PassthroughSubject<UIBarButtonItem, Never>()
    let showErrorSubject = PassthroughSubject<GeneralErrorType, Never>()
    let searchTextSubject = CurrentValueSubject<String, Never>.init("")
    let didSelectRowSubject = PassthroughSubject<IndexPath, Never>()
    private let selectedCategoriesSubject = PassthroughSubject<[Category], Never>()
    private let activityIndicator = ActivityIndicator()
    
    // MARK: - Output
    func createCellViewModel(with marker: PhotoDVO) -> TimelineCellViewModel {
        return TimelineCellViewModel(firestoreService: firestoreService, marker: marker)
    }
    
    var reloadDataSubject = PassthroughSubject<Void, Never>()
    
    var loadingPublisher: AnyPublisher<Bool, Never> {
        return activityIndicator.loading.eraseToAnyPublisher()
    }
    
    var isSearching: Bool {
        return !searchTextSubject.value.isEmpty
    }
    
    var numberOfSections: Int {
        return isSearching ? searchingMarkers.count : categorizedMarkers.count
    }
    
    func getMarker(at indexPath: IndexPath) -> PhotoDVO? {
        guard let key = isSearching ? searchingHeaderTitles[at: indexPath.section] : headerTitles[at: indexPath.section] else { return nil }
        guard let markers = isSearching ? searchingMarkers[key] : categorizedMarkers[key] else { return nil }
        return markers[at: indexPath.row]
    }
    
    func getTitle(for section: Int) -> String? {
        return isSearching ? searchingHeaderTitles[at: section] : headerTitles[at: section]
    }
    
    func getNumberOfRows(in section: Int) -> Int {
        guard let key = isSearching ? searchingHeaderTitles[at: section] : headerTitles[at: section] else { return 0 }
        guard let markers = isSearching ? searchingMarkers[key] : categorizedMarkers[key] else { return 0 }
        return markers.count
    }
    
    // MARK: - Helpers
    private func getUserMarkers() {
        firestoreService.getUserMarkers()
            .receive(on: DispatchQueue.main)
            .trackActivity(activityIndicator)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.showErrorSubject.send(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] markers in
                guard let results = self?.configureDataSource(with: markers) else { return }
                self?.allMarkers = results.markers
                self?.categorizedMarkers = results.markers
                self?.headerTitles = results.titles
                self?.reloadDataSubject.send()
            })
            .store(in: cancelBag)
    }
    
    private func configureDataSource(with markers: [PhotoDVO]) -> (markers: [String: [PhotoDVO]], titles: [String]) {
        guard !markers.isEmpty else { return ([:], []) }
        var groupedMarkers = [String: [PhotoDVO]]()
        
        for marker in markers {
            if let marks = groupedMarkers[marker.date.monthAndYear],
               marks.first?.date.monthAndYear == marker.date.monthAndYear {
                groupedMarkers[marker.date.monthAndYear] = marks + [marker]
            } else {
                groupedMarkers[marker.date.monthAndYear] = [marker]
            }
        }
        let titles = [String](groupedMarkers.keys).sorted { $0.toMonthAndYearDate > $1.toMonthAndYearDate }
        return (groupedMarkers, titles)
    }
    
    private func searchMarkersWith(hashtag: String) {
        let markers = self.categorizedMarkers.values.flatMap { $0 }
        var filteredMarkers = [PhotoDVO]()
        
        mainLoop: for marker in markers {
            for tag in marker.hashtags where tag.lowercased().contains(hashtag.lowercased()) {
                filteredMarkers.append(marker)
                continue mainLoop
            }
        }
        let results = self.configureDataSource(with: filteredMarkers)
        self.searchingMarkers = results.markers
        self.searchingHeaderTitles = results.titles
    }
    
}
