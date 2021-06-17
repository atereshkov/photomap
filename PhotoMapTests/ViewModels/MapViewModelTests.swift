//
//  MapViewModelTests.swift
//  PhotoMapTests
//
//  Created by Dzmitry Makarevich on 4/27/21.
//

import XCTest
import Combine
import CoreLocation
import MapKit
@testable import PhotoMap

class MapViewModelTests: XCTestCase {
    var viewModel: MapViewModelType!
    var coordinator: MapCoordinator!
    var diContainer: DIContainerType!
    var firestoreService: FirestoreServiceMock!
    var cancelBag: CancelBag!

    override func setUpWithError() throws {
        cancelBag = CancelBag()
        diContainer = DIContainerMock()
        let serviceType: FirestoreServiceType = diContainer.resolve()
        firestoreService = serviceType as? FirestoreServiceMock
        coordinator = MapCoordinator(diContainer: diContainer)
        viewModel = MapViewModel(coordinator: coordinator, diContainer: diContainer)
    }

    override func tearDownWithError() throws {
        cancelBag = nil
        diContainer = nil
        coordinator = nil
        viewModel = nil
        firestoreService = nil
    }

//    func testIsShowUserLocation_EnableLocation_ShouldBeTrue() {
//        // Arrange
//        var isEqual = false
//        XCTAssertFalse(viewModel.isShowUserLocation)
//        let locationService: LocationServiceType = diContainer.resolve()
//        guard let mockService = locationService as? LocationServiceMock else {
//            XCTAssertNotNil(nil, "Typecast Error!")
//            return
//        }
//
//        // Act
//        mockService.status
//            .sink { status in
//                isEqual = status == .authorizedWhenInUse
//            }
//            .store(in: cancelBag)
//
//        mockService.enableService()
//
//        // Assert
//        XCTAssertTrue(viewModel.isShowUserLocation)
//        XCTAssertTrue(isEqual)
//    }
//
//    func  testIsShowUserLocation_DisableLocation_ShouldBeFalse() {
//        // Arrange
//        var isEqual = false
//        XCTAssertFalse(viewModel.isShowUserLocation)
//        let locationService: LocationServiceType = diContainer.resolve()
//        guard let mockService = locationService as? LocationServiceMock else {
//            XCTAssertNotNil(nil, "Typecast Error!")
//            return
//        }
//        
//        // Act
//        mockService.status
//            .sink { status in
//                isEqual = status == .denied
//            }
//            .store(in: cancelBag)
//
//        mockService.enableService()
//        mockService.disableService()
//
//        // Assert
//        XCTAssertFalse(viewModel.isShowUserLocation)
//        XCTAssertTrue(isEqual)
//    }
//
//    func testTapOnMap_FolowModeOn_ShouldOnDiscoveryMode() {
//        XCTAssertTrue(viewModel.isFollowModeOn)
//
//        viewModel.enableDiscoveryModeSubject.send(.tap())
//
//        XCTAssertFalse(viewModel.isFollowModeOn)
//    }
//
//    func testTapOnPhotoButton_FolowModeOn_ShouldOnDiscoveryMode() {
//        XCTAssertTrue(viewModel.isFollowModeOn)
//
//        viewModel.photoButtonSubject.send(CLLocationCoordinate2D())
//
//        XCTAssertFalse(viewModel.isFollowModeOn)
//    }
//
//    func testTapOnCategoryButton_FolowModeOn_ShouldOnDiscoveryMode() {
//        XCTAssertTrue(viewModel.isFollowModeOn)
//
//        viewModel.categoryButtonSubject.send(UIControl())
//
//        XCTAssertFalse(viewModel.isFollowModeOn)
//    }

    func testTapOnPhotoButton_ShouldShowPhotoAlert() {
        // Arrange
        var isShow = false

        // Act
        coordinator.showPhotoMenuAlertSubject
            .sink { _ in
                isShow = true
            }
            .store(in: cancelBag)
        
        viewModel.photoButtonSubject.send(CLLocationCoordinate2D())

        // Assert
        XCTAssertTrue(isShow)
    }

//    func testTapOnNavigationButton_ShouldSwitchMode() {
//        XCTAssertTrue(viewModel.isFollowModeOn)
//
//        viewModel.navigationButtonSubject.send(UIControl())
//        XCTAssertFalse(viewModel.isFollowModeOn)
//
//        viewModel.navigationButtonSubject.send(UIControl())
//        XCTAssertTrue(viewModel.isFollowModeOn)
//    }
//
//    func testCategoryButtonPublisher_WhenTapped_ShouldShowCategoryFilter() {
//        // Arrange
//        XCTAssertTrue(viewModel.isFollowModeOn)
//
//        // Act
//        viewModel.categoryButtonSubject.send(UIControl())
//
//        // Assert
//        XCTAssertFalse(viewModel.isFollowModeOn)
//    }

    func testLoadPhotosForVisibleArea_WithExistingPhotos_ShouldReturnPhotos() {
        // Arrange
        guard let viewModel = viewModel as? MapViewModel else {
            XCTAssertTrue(false)
            return
        }

        let expectation = XCTestExpectation()
        firestoreService.photos = getPhotos()

        // Act
        viewModel.$photos
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: cancelBag)

        viewModel.loadUserPhotosSubject.send(MKMapRect())

        // Assert
        wait(for: [expectation], timeout: 1)
        XCTAssertFalse(viewModel.photos.isEmpty)
    }

    func testLoadPhotosForVisibleArea_WithoutPhotos_ShouldReturnEmptyArray() {
        // Arrange
        guard let viewModel = viewModel as? MapViewModel else {
            XCTAssertTrue(false)
            return
        }

        let expectation = XCTestExpectation()
        firestoreService.photos = nil

        // Act
        viewModel.$photos
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: cancelBag)

        viewModel.loadUserPhotosSubject.send(MKMapRect())

        // Assert
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(viewModel.photos.isEmpty)
    }

    private func getPhotos() -> [Photo] {
        // swiftlint:disable line_length
        [Photo(id: "1", image: UIImage(), imageUrls: [], date: Date(), description: "", category: nil, coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)),
         Photo(id: "1", image: UIImage(), imageUrls: [], date: Date(), description: "", category: nil, coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))]
        // swiftlint:enable line_length
    }
}
