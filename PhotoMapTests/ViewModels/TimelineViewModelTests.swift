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
        firestoreService.userHasDocuments = true
        firestoreService.isEmptyPhotos = false
        
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
        XCTAssertTrue(firestoreService.getMarkersEndWithValues)
    }
    
    func testIfAuthorizedThenGetMarksShouldBeCalledWithValues() {
        firestoreService.userHasDocuments = true
        firestoreService.isEmptyPhotos = false
        
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
        firestoreService.userHasDocuments = true
        firestoreService.isEmptyPhotos = false
        let photos = firestoreService.photos
        let section = 0
        
        let expectation = XCTestExpectation()
        
        viewModel.reloadDataSubject.sink(receiveValue: { _ in
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.viewDidLoadSubject.send()
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(viewModel.getTitle(for: section), photos.first?.date.monthAndYear)
    }
    
    func testIfGetValuesThenShouldGetChosenMarker() {
        firestoreService.userHasDocuments = true
        firestoreService.isEmptyPhotos = false
        let markers = firestoreService.photos
        
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
    }
    
    func testIfGetValuesShouldReturnNumberOfRows() {
        firestoreService.userHasDocuments = true
        firestoreService.isEmptyPhotos = false
        
        let expectedNumberOfRows = firestoreService.photos.count
        let expectation = XCTestExpectation()
        
        viewModel.reloadDataSubject.sink(receiveValue: { _ in
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.viewDidLoadSubject.send()
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(viewModel.getNumberOfRows(in: 0), expectedNumberOfRows)
    }
    
    func testWhenGettingCategoriesShouldFilterMarkersCorrectly() {
        guard let viewModel = viewModel as? TimelineViewModel else { return }
 
        firestoreService.userHasDocuments = true
        firestoreService.isEmptyCategories = false
        firestoreService.isEmptyPhotos = false
        
        let categories = [
            firestoreService.categories[0],
            firestoreService.categories[1]
        ]
        
        // Arrange
        let expectedNumberOfMarkers = 6
        let expectedNumberOfTitles = 1
        let expectation = XCTestExpectation()
        var count = 0
        
        viewModel.reloadDataSubject.dropFirst().sink(receiveValue: { _ in
            count += 1
            if count == 2 {
                expectation.fulfill()
            }
        })
        .store(in: cancelBag)
        
        viewModel.viewDidLoadSubject.send()
        
        // Act
        coordinator.doneButtonPressedWithCategoriesSubject.send(categories)
        wait(for: [expectation], timeout: 2)
        
        // Assert
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
