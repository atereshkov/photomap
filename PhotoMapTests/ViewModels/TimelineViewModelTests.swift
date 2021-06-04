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
        firestoreService.markers = [Marker(category: "Nature", date: Date(), photoURLString: "url", location: (35, 89))]
        
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
        
        viewModel.viewDidLoad()
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(expectedValues, results)
    }
    
    func testIfNotAuthorizedThenCantGetMarks() {
        XCTAssertFalse(firestoreService.getMarkersCalled)
        viewModel.viewDidLoad()
        XCTAssertEqual(viewModel.numberOfSections, 0)
        XCTAssertTrue(firestoreService.getMarkersCalled)
        XCTAssertFalse(firestoreService.getMarkersEndWithValues)
    }
    
    func testIfAuthorizedThenGetMarksShouldBeCalledWithValues() {
        firestoreService.userId = "id"
        firestoreService.userHasDocuments = true
        firestoreService.markers = [Marker(category: "Nature", date: Date(), photoURLString: "url", location: (35, 89))]
        
        let expectation = XCTestExpectation()
        
        viewModel.reloadDataSubject.sink(receiveValue: { _ in
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        XCTAssertFalse(firestoreService.getMarkersCalled)
        viewModel.viewDidLoad()
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
                   hashtags: ["#nature"], photoURLString: "url", location: (15, 28))
        ]
        firestoreService.markers = markers
        
        let expectation = XCTestExpectation()
        
        viewModel.reloadDataSubject.sink(receiveValue: { _ in
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.viewDidLoad()
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(viewModel.getTitle(for: markers.count - 1), markers[markers.count - 1].date.monthAndYear)
    }
    
    func testIfGetValuesThenShouldGetChosenMarker() {
        firestoreService.userId = "id"
        firestoreService.userHasDocuments = true
        let markers = [
            Marker(category: "Nature", date: Date(), description: "nature",
                   hashtags: ["#nature"], photoURLString: "url", location: (15, 28))
        ]
        firestoreService.markers = markers
        
        let expectation = XCTestExpectation()
        
        viewModel.reloadDataSubject.sink(receiveValue: { _ in
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.viewDidLoad()
        wait(for: [expectation], timeout: 2)
        let indexPath = IndexPath(row: markers.count - 1, section: 0)
        XCTAssertEqual(viewModel.getMarker(at: indexPath)?.description, markers[at: indexPath.row]?.description)
        XCTAssertEqual(viewModel.getMarker(at: indexPath)?.date, markers[at: indexPath.row]?.date)
        XCTAssertEqual(viewModel.getMarker(at: indexPath)?.hashtags, markers[at: indexPath.row]?.hashtags)
    }
    
    func testIfGetValuesShouldReturnNumberOfRows() {
        firestoreService.userId = "id"
        firestoreService.userHasDocuments = true
        let markers = [Marker(category: "Nature", date: Date(), photoURLString: "url", location: (35, 89))]
        firestoreService.markers = markers
        
        let expectedNumberOfRows = markers.count
        let expectation = XCTestExpectation()
        
        viewModel.reloadDataSubject.sink(receiveValue: { _ in
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.viewDidLoad()
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(viewModel.getNumberOfRows(in: markers.count - 1), expectedNumberOfRows)
    }
    
}
