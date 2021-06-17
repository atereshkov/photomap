//
//  TimelineViewModelTests.swift
//  PhotoMapTests
//
//  Created by yurykasper on 27.05.21.
//

import Combine
import Foundation
import XCTest
@testable import PhotoMap

class TimelineViewModelTests: XCTestCase {
    
    var viewModel: TimelineViewModelType!
    var diContainer: DIContainerType!
    var coordinator: TimelineCoordinator!
    var firestoreService: FirestoreServiceMock!
    var cancelBag: CancelBag!
    
    override func setUpWithError() throws {
        diContainer = DIContainerMock()
        let firestoreServiceDI: FirestoreServiceType = diContainer.resolve()
        firestoreService = firestoreServiceDI as? FirestoreServiceMock
        
        coordinator = TimelineCoordinatorMock(diContainer: diContainer)
        viewModel = TimelineViewModel(coordinator: coordinator, diContainer: diContainer)
        
        cancelBag = CancelBag()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        diContainer = nil
        coordinator = nil
        firestoreService = nil
        cancelBag = nil
    }
    
    func testIndicatorHiddenOnStart() {
        viewModel.loadingPublisher.sink(receiveValue: { isLoading in
            XCTAssertFalse(isLoading)
        })
        .store(in: cancelBag)
    }
    
    func testIfGettingMarksThenIndicatorShouldAppear() {
        firestoreService.userId = "id"
        firestoreService.userHasDocuments = true
        firestoreService.markers = [Marker(category: "Nature", date: Date(), images: ["url"], location: nil)]
        
        let expectation = XCTestExpectation()
        let expectedValues = [false, true, false]
        var results = [Bool]()
        var count = 0
        
        viewModel.loadingPublisher.sink(receiveValue: { isLoading in
            results.append(isLoading)
            count += 1
            if count == expectedValues.count {
                expectation.fulfill()
            }
        })
        .store(in: cancelBag)
        
        viewModel.viewDidLoadSubject.send()
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(expectedValues, results)
    }
    
    func testIfNotAuthorizedThenCantGetMarks() {
        XCTAssertFalse(firestoreService.getMarkersCalled)
        viewModel.viewDidLoadSubject.send()
        XCTAssertEqual(viewModel.numberOfSections, 0)
        XCTAssertTrue(firestoreService.getMarkersCalled)
        XCTAssertFalse(firestoreService.getMarkersEndWithValues)
    }
    
    func testIfAuthorizedThenGetMarksShouldBeCalledWithValues() {
        firestoreService.userId = "id"
        firestoreService.userHasDocuments = true
        firestoreService.markers = [Marker(category: "Nature", date: Date(), images: ["url"], location: nil)]
        
        let expectation = XCTestExpectation()
        
        viewModel.reloadDataSubject.sink(receiveValue: { _ in
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        XCTAssertFalse(firestoreService.getMarkersCalled)
        viewModel.viewDidLoadSubject.send()
        wait(for: [expectation], timeout: 2)
        XCTAssertTrue(firestoreService.getMarkersCalled)
        XCTAssertTrue(firestoreService.getMarkersEndWithValues)
        XCTAssertTrue(viewModel.numberOfSections > 0)
    }
    
    func testIfGetValuesThenShouldGetTitlesForValues() {
        firestoreService.userId = "id"
        firestoreService.userHasDocuments = true
        let markers = [
            Marker(category: "Nature", date: Date(), description: "nature",
                   hashtags: ["#nature"], images: ["url"], location: nil)
        ]
        firestoreService.markers = markers
        
        let expectation = XCTestExpectation()
        
        viewModel.reloadDataSubject.sink(receiveValue: { _ in
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.viewDidLoadSubject.send()
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(viewModel.getTitle(for: markers.count - 1), markers[markers.count - 1].date.monthAndYear)
    }
    
    func testIfGetValuesThenShouldGetChosenMarker() {
        firestoreService.userId = "id"
        firestoreService.userHasDocuments = true
        let markers = [
            Marker(category: "Nature", date: Date(), description: "nature",
                   hashtags: ["#nature"], images: ["url"], location: nil)
        ]
        firestoreService.markers = markers
        
        let expectation = XCTestExpectation()
        
        viewModel.reloadDataSubject.sink(receiveValue: { _ in
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.viewDidLoadSubject.send()
        wait(for: [expectation], timeout: 2)
        let indexPath = IndexPath(row: markers.count - 1, section: 0)
        XCTAssertEqual(viewModel.getMarker(at: indexPath)?.description, markers[at: indexPath.row]?.description)
        XCTAssertEqual(viewModel.getMarker(at: indexPath)?.date, markers[at: indexPath.row]?.date)
        XCTAssertEqual(viewModel.getMarker(at: indexPath)?.hashtags, markers[at: indexPath.row]?.hashtags)
    }
    
    func testIfGetValuesShouldReturnNumberOfRows() {
        firestoreService.userId = "id"
        firestoreService.userHasDocuments = true
        let markers = [Marker(category: "Nature", date: Date(), images: ["url"], location: nil)]
        firestoreService.markers = markers
        
        let expectedNumberOfRows = markers.count
        let expectation = XCTestExpectation()
        
        viewModel.reloadDataSubject.sink(receiveValue: { _ in
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.viewDidLoadSubject.send()
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(viewModel.getNumberOfRows(in: markers.count - 1), expectedNumberOfRows)
    }
    
    func testWhenGettingCategoriesShouldFilterMarkersCorrectly() {
        guard let viewModel = viewModel as? TimelineViewModel else { return }
        
        firestoreService.userId = "id"
        firestoreService.userHasDocuments = true
        let markers = [
            Marker(category: "NATURE", date: Date(), photoURLString: "url", location: nil),
            Marker(category: "NATURE", date: Date(), photoURLString: "url", location: nil),
            Marker(category: "DEFAULT", date: Date(), photoURLString: "url", location: nil),
            Marker(category: "FRIENDS", date: Date(), photoURLString: "url", location: nil),
            Marker(category: "FRIENDS", date: Date(), photoURLString: "url", location: nil),
            Marker(category: "FRIENDS", date: Date(), photoURLString: "url", location: nil)
        ]
        firestoreService.markers = markers
        
        let categories = [
            PhotoMap.Category(id: "1", name: "DEFAULT", color: "blue"),
            PhotoMap.Category(id: "2", name: "NATURE", color: "green")
        ]
        
        let expectedNumberOfMarkers = markers.filter { $0.category ==  "DEFAULT" || $0.category == "NATURE" }.count
        let expectedNumberOfTitles = Set(markers.map { $0.date.monthAndYear }).count
        let expectation = XCTestExpectation()
        
        viewModel.reloadDataSubject.dropFirst().sink(receiveValue: { _ in
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.viewDidLoadSubject.send()
        coordinator.doneButtonPressedWithCategoriesSubject.send(categories)
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(viewModel.categorizedMarkers.values.flatMap { $0 }.count, expectedNumberOfMarkers)
        XCTAssertEqual(viewModel.headerTitles.count, expectedNumberOfTitles)
    }
    
    func testWhenPressCategoryButtonCoordinatorShouldShowCategoryScreen() {
        let expectation = XCTestExpectation()
        var presentCategoryScreenCalled = false
        
        coordinator.categoryButtonTapped.sink(receiveValue: { _ in
            presentCategoryScreenCalled = true
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.categoryButtonSubject.send(UIBarButtonItem())
        wait(for: [expectation], timeout: 2)
        
        XCTAssertTrue(presentCategoryScreenCalled)
    }
    
    func testIfErrorOccurredCoordinatorShouldShowErrorAlert() {
        guard let viewModel = viewModel as? TimelineViewModel else { return }
        
        let expectation = XCTestExpectation()
        var showErrorAlertCalled = false
        
        coordinator.showErrorAlertSubject.sink(receiveValue: { _ in
            showErrorAlertCalled = true
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.showErrorSubject.send(FirestoreError.custom("error"))
        wait(for: [expectation], timeout: 2)
        
        XCTAssertTrue(showErrorAlertCalled)
    }
    
}
