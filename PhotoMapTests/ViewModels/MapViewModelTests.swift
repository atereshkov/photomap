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

    func testTapOnPhotoButton_FolowModeOn_ShouldOnDiscoveryMode() {
        XCTAssertEqual(viewModel.userTrackingMode, MKUserTrackingMode.follow)

        viewModel.photoButtonSubject.send(CLLocationCoordinate2D())

        XCTAssertEqual(viewModel.userTrackingMode, MKUserTrackingMode.none)
    }

    func testTapOnCategoryButton_FolowModeOn_ShouldOnDiscoveryMode() {
        XCTAssertEqual(viewModel.userTrackingMode, MKUserTrackingMode.follow)

        viewModel.categoryButtonSubject.send(UIControl())

        XCTAssertEqual(viewModel.userTrackingMode, MKUserTrackingMode.none)
    }

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

    func testCategoryButtonPublisher_WhenTapped_ShouldEnableDiscoveryMode() {
        // Arrange
        XCTAssertEqual(viewModel.userTrackingMode, MKUserTrackingMode.follow)

        // Act
        viewModel.categoryButtonSubject.send(UIControl())

        // Assert
        XCTAssertEqual(viewModel.userTrackingMode, MKUserTrackingMode.none)
    }
    
    func testCategoryButtonPublisher_WhenTapped_ShouldShowCategoryFilter() {
        // Arrange
        var isOpen = false

        // Act
        coordinator.showCategoriesScreenSubject
            .sink(receiveValue: { _ in isOpen = true })
            .store(in: cancelBag)

        viewModel.categoryButtonSubject.send(UIControl())

        // Assert
        XCTAssertTrue(isOpen)
    }

    func testLoadPhotosForVisibleArea_WithExistingPhotos_ShouldReturnPhotos() {
        // Arrange
        guard let viewModel = viewModel as? MapViewModel else {
            XCTAssertTrue(false)
            return
        }

        let expectation = XCTestExpectation()

        firestoreService.setCategories()
        firestoreService.setPhotos()

        // Act
        viewModel.$photos
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: cancelBag)

        viewModel.loadUserPhotosSubject.send(MKMapRect())

        // Assert
        wait(for: [expectation], timeout: 2)

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

    func testTapMapViewGesture_ShouldAnableDiscoveryMode() {
        // Arrange
        XCTAssertEqual(viewModel.userTrackingMode, MKUserTrackingMode.follow)

        // Act
        viewModel.tapMapViewGestureSubject.send(.tap())

        // Assert
        XCTAssertEqual(viewModel.userTrackingMode, MKUserTrackingMode.none)
    }

    func testFilteredCategories_WithCategories_ShouldBeNotEmpty() {
        // Arrange
        XCTAssertTrue(viewModel.filteredCategories.isEmpty)

        // Act
        coordinator.doneButtonPressedWithCategoriesSubject.send([Category(id: "", name: "", color: "")])

        // Assert
        XCTAssertFalse(viewModel.filteredCategories.isEmpty)
    }

    func testVisiblePhotos_WithNotEmptyFilteredCategories_ShouldNotBeEqualPhotos() {
        // Prepare: Loading photos
        guard let viewModel = viewModel as? MapViewModel else {
            XCTAssertTrue(false)
            return
        }

        let prepareExpectation = XCTestExpectation()

        firestoreService.setCategories()
        firestoreService.setPhotos()
        viewModel.loadUserPhotosSubject.send(MKMapRect())

        viewModel.$photos
            .dropFirst()
            .sink { _ in prepareExpectation.fulfill() }
            .store(in: cancelBag)
        
        wait(for: [prepareExpectation], timeout: 2)

        XCTAssertTrue(viewModel.filteredCategories.isEmpty)
        XCTAssertEqual(viewModel.photos.count, viewModel.visiblePhotos.count)

        // Arrange
        let expectation = XCTestExpectation()
        
        // Act
        viewModel.$visiblePhotos
            .dropFirst(2)
            .sink(receiveValue: { _ in
                expectation.fulfill()
            })
            .store(in: cancelBag)

        coordinator.doneButtonPressedWithCategoriesSubject.send([Category(id: "1", name: "DEFAULT", color: "#368EDF")])

        // Assert
        wait(for: [expectation], timeout: 0.2)

        XCTAssertFalse(viewModel.filteredCategories.isEmpty)
        XCTAssertNotEqual(viewModel.photos.count, viewModel.visiblePhotos.count)
    }

}
