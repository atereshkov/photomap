//
//  FullPhotoViewModelTests.swift
//  PhotoMapTests
//
//  Created by yurykasper on 23.06.21.
//

import Foundation
import XCTest
@testable import PhotoMap

class FullPhotoViewModelTests: XCTestCase {
    var diContainer: DIContainerType!
    var coordinator: FullPhotoCoordinator!
    var firestoreService: FirestoreServiceMock!
    var cancelBag: CancelBag!
    
    override func setUpWithError() throws {
        diContainer = DIContainerMock()
        coordinator = FullPhotoCoordinator(diContainer: diContainer)
        let firestoreServiceDI: FirestoreServiceType = diContainer.resolve()
        firestoreService = firestoreServiceDI as? FirestoreServiceMock
        firestoreService.userId = "id"
        cancelBag = CancelBag()
    }
    
    override func tearDownWithError() throws {
        diContainer = nil
        firestoreService = nil
        coordinator = nil
        cancelBag = nil
    }
    
    func test_IfErrorOccurred_DisplayDefaultImage() {
        let marker = Marker(category: "default", date: Date(), description: "description",
                                             hashtags: [], images: ["url"], location: nil)
        firestoreService.error = .custom("error")
        
        let viewModel = FullPhotoViewModel(coordinator: coordinator, diContainer: diContainer, marker: marker)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertNotNil(viewModel.description)
        XCTAssertNotNil(viewModel.date)
        XCTAssertEqual(viewModel.image, UIImage(systemName: "photo"))
    }
    
    func test_IfImageExists_GetItFromCacheDocuments() {
        let marker = Marker(category: "default", date: Date(), description: "description",
                                             hashtags: [], images: ["url"], location: nil)
        let localImage = UIImage(systemName: "scribble")
        firestoreService.localImage = localImage
        
        let viewModel = FullPhotoViewModel(coordinator: coordinator, diContainer: diContainer, marker: marker)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertNotNil(viewModel.description)
        XCTAssertNotNil(viewModel.date)
        XCTAssertNotEqual(viewModel.image, UIImage(systemName: "photo"))
    }
    
    func test_WhenTap_HideNavbarAndFooterView() {
        let marker = Marker(category: "default", date: Date(), description: "description",
                                             hashtags: [], images: ["url"], location: nil)
        let localImage = UIImage(systemName: "scribble")
        firestoreService.localImage = localImage
        
        let viewModel = FullPhotoViewModel(coordinator: coordinator, diContainer: diContainer, marker: marker)
        
        let expectation = XCTestExpectation()
        var hideNavbarAndFooter = false
        
        viewModel.imageTappedSubject.sink(receiveValue: { _ in
            hideNavbarAndFooter = !hideNavbarAndFooter
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.imageTappedSubject.send(GestureType.tap())
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(hideNavbarAndFooter, viewModel.footerAndNavBarHidden)
    }
    
    func test_WhenScreenDisappear_CoordinatorCallDisappearMethod() {
        let marker = Marker(category: "default", date: Date(), description: "description",
                                             hashtags: [], images: ["url"], location: nil)
        let localImage = UIImage(systemName: "scribble")
        firestoreService.localImage = localImage
        
        let viewModel = FullPhotoViewModel(coordinator: coordinator, diContainer: diContainer, marker: marker)
        
        let expectation = XCTestExpectation()
        var disappearCalled = false
        
        coordinator.viewDidDisappearSubject.sink(receiveValue: { _ in
            disappearCalled = true
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.viewDidDisappearSubject.send()
        wait(for: [expectation], timeout: 2)
        XCTAssertTrue(disappearCalled)
    }
}
