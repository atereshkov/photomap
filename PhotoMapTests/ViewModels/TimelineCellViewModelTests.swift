//
//  TimelineCellViewModelTests.swift
//  PhotoMapTests
//
//  Created by yurykasper on 16.06.21.
//

import Foundation
import XCTest
import CoreLocation
@testable import PhotoMap

class TimelineCellViewModelTests: XCTestCase {

    var diContainer: DIContainerType!
    var firestoreService: FirestoreServiceMock!
    
    override func setUpWithError() throws {
        diContainer = DIContainerMock()
        let firestoreServiceDI: FirestoreServiceType = diContainer.resolve()
        firestoreService = firestoreServiceDI as? FirestoreServiceMock
    }
    
    override func tearDownWithError() throws {
        diContainer = nil
        firestoreService = nil
    }
    
    func testIfNoPhotoThenShouldDownloadItFromFirebase() {
        let marker = firestoreService.photos[0]
        firestoreService.downloadImage = UIImage(systemName: "face.smiling")
        let viewModel = TimelineCellViewModel(firestoreService: firestoreService, marker: marker)
        
        XCTAssertNotNil(viewModel.description)
        XCTAssertNotNil(viewModel.date)
        XCTAssertNotNil(viewModel.category)
        XCTAssertNotNil(viewModel.image)
        XCTAssertTrue(firestoreService.downloadImageEndWithImage)
        XCTAssertNotEqual(viewModel.image, UIImage(systemName: "photo"))
    }
    
    func test_IfImageExists_LoadItFromCacheDocuments() {
        let marker = firestoreService.photos[0]
        firestoreService.localImage = UIImage(systemName: "face.smiling")
        let viewModel = TimelineCellViewModel(firestoreService: firestoreService, marker: marker)
        
        XCTAssertNotNil(viewModel.description)
        XCTAssertNotNil(viewModel.date)
        XCTAssertNotNil(viewModel.category)
        XCTAssertNotNil(viewModel.image)
        XCTAssertTrue(firestoreService.downloadImageEndWithImage)
        XCTAssertNotEqual(viewModel.image, UIImage(systemName: "photo"))
    }
    
    func testIfErrorOccurredShouldDisplayDefaultImage() {
        let marker = firestoreService.photos[0]
        firestoreService.error = FirestoreError.custom("error")
        let viewModel = TimelineCellViewModel(firestoreService: firestoreService, marker: marker)
        
        XCTAssertNotNil(viewModel.description)
        XCTAssertNotNil(viewModel.date)
        XCTAssertNotNil(viewModel.category)
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.image, UIImage(systemName: "photo"))
    }

}
