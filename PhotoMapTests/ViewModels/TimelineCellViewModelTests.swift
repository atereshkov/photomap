//
//  TimelineCellViewModelTests.swift
//  PhotoMapTests
//
//  Created by yurykasper on 16.06.21.
//

import Foundation
import XCTest
@testable import PhotoMap

class TimelineCellViewModelTests: XCTestCase {

    var diContainer: DIContainerType!
    var firestoreService: FirestoreServiceMock!
    
    override func setUpWithError() throws {
        diContainer = DIContainerMock()
        let firestoreServiceDI: FirestoreServiceType = diContainer.resolve()
        firestoreService = firestoreServiceDI as? FirestoreServiceMock
        firestoreService.userId = "id"
    }
    
    override func tearDownWithError() throws {
        diContainer = nil
        firestoreService = nil
    }
    
    func testIfNoPhotoThenShouldDownloadItFromFirebase() {
        let marker = Marker(category: "DEFAULT", date: Date(), description: "", hashtags: [],
                                                              images: ["url"], location: nil)
        firestoreService.downloadImage = UIImage(systemName: "face.smiling")
        let viewModel = TimelineCellViewModel(firestoreService: firestoreService, marker: marker)
        
        XCTAssertNotNil(viewModel.description)
        XCTAssertNotNil(viewModel.date)
        XCTAssertNotNil(viewModel.category)
        XCTAssertNotNil(viewModel.image)
        XCTAssertTrue(firestoreService.downloadImageEndWithImage)
        XCTAssertNotEqual(viewModel.image, UIImage(systemName: "photo"))
    }
    
    func testIfHavePhotoLoadItFromCacheDocuments() {
        let marker = Marker(category: "DEFAULT", date: Date(), description: "", hashtags: [],
                                                              images: ["url"], location: nil)
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
        let marker = Marker(category: "DEFAULT", date: Date(), description: "", hashtags: [],
                                                              images: ["url"], location: nil)
        firestoreService.error = FirestoreError.custom("error")
        let viewModel = TimelineCellViewModel(firestoreService: firestoreService, marker: marker)
        
        XCTAssertNotNil(viewModel.description)
        XCTAssertNotNil(viewModel.date)
        XCTAssertNotNil(viewModel.category)
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.image, UIImage(systemName: "photo"))
    }

}
