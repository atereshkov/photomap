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
    var coordinator: TimelineCoordinatorMock!
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
        
        viewModel.viewDidLoad()
        
        viewModel.loadingPublisher.first().sink(receiveValue: { isLoading in
            XCTAssertTrue(isLoading)
        })
        .store(in: cancelBag)
    }
    
    func testIfNotAuthorizedThenCantGetMarks() {
        XCTAssertFalse(firestoreService.getMarkersCalled)
        viewModel.viewDidLoad()
        XCTAssertEqual(viewModel.numberOfSections, 0)
        XCTAssertTrue(firestoreService.getMarkersCalled)
        XCTAssertFalse(firestoreService.getMarkersEndWithValues)
    }
    
    func testIfAuthorizedThenGetMarksShouldBeCalled() {
        firestoreService.userId = "id"
        firestoreService.userHasDocuments = true
        firestoreService.markers = [Marker(category: "Nature", date: Date(), photoURLString: "url", location: (35, 89))]
        
        XCTAssertFalse(firestoreService.getMarkersCalled)
        viewModel.viewDidLoad()
        XCTAssertTrue(firestoreService.getMarkersCalled)
        XCTAssertTrue(firestoreService.getMarkersEndWithValues)
    }
    
}
