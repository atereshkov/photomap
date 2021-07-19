//
//  MapPhotoViewModelTests.swift
//  PhotoMapTests
//
//  Created by Dzmitry Makarevich on 13.05.21.
//

import XCTest
import Combine
import CoreLocation
@testable import PhotoMap

class MapPhotoViewModelTests: XCTestCase {
    var viewModel: MapPhotoViewModelType!
    var coordinator: MapPhotoCoordinator!
    var diContainer: DIContainerType!
    var firestoreService: FirestoreServiceMock!
    var cancelBag: CancelBag!

    override func setUpWithError() throws {
        cancelBag = CancelBag()
        diContainer = DIContainerMock()
        let serviceType: FirestoreServiceType = diContainer.resolve()
        firestoreService = serviceType as? FirestoreServiceMock
        coordinator = MapPhotoCoordinator(diContainer: diContainer)
        let photo = PhotoDVO(image: UIImage(), coordinate: CLLocationCoordinate2D())
        viewModel = MapPhotoViewModel(coordinator: coordinator, diContainer: diContainer, photo: photo)
    }

    override func tearDownWithError() throws {
        cancelBag = nil
        diContainer = nil
        firestoreService = nil
        viewModel = nil
        coordinator = nil
    }

    func testTapOnCancelButton_ShouldCloseMapPopup() {
        // Arrange
        var isClose = false

        // Act
        coordinator.dismissSubject
            .sink { _ in
                isClose = true
            }
            .store(in: cancelBag)
        viewModel.cancelButtonSubject.send(UIControl())

        // Assert
        XCTAssertTrue(isClose)
    }

    func testTapOnCategoryView_WithNoEmptyCategories_ShouldShowCategoryPickerView() {
        // Arrange
        XCTAssertTrue(viewModel.isHiddenCategoryPicker)

        // Act
        viewModel.categoryViewSubject.send(.tap())

        // Assert
        XCTAssertFalse(viewModel.isHiddenCategoryPicker)
    }

    func testTapOnCloseBarButton_ShouldShowCategoryPickerView() {
        // Arrange
        viewModel.categoryViewSubject.send(.tap())
        XCTAssertFalse(viewModel.isHiddenCategoryPicker)

        // Act        
        viewModel.closeBarButtonSubject.send((true))

        // Assert
        XCTAssertTrue(viewModel.isHiddenCategoryPicker)
    }

    func testCategoryPublisher_ShouldBeNotNil() {
        XCTAssertNotNil(viewModel.categoryPublisher)
    }

    func testPhotoPublisher_ShouldBeNotNil() {
        XCTAssertNotNil(viewModel.photoPublisher)
    }

    func testTapOnCancelButton_ShouldCloseScreen() {
        // Arrange
        var isDismiss = false
        coordinator.dismissSubject
            .sink { _ in
                isDismiss = true
            }
            .store(in: cancelBag)

        // Act
        viewModel.cancelButtonSubject.send(UIControl())

        // Assert
        XCTAssertTrue(isDismiss)
    }

    func testTapOnDoneButton_WithError_ShouldShowErrorAlert() {
        // Arrange
        let expectation = XCTestExpectation()
        var isShow = false
        firestoreService.error = .nonMatchingChecksum

        coordinator.errorAlertSubject
            .sink { _ in
                isShow = true
                expectation.fulfill()
            }
            .store(in: cancelBag)

        // Act
        viewModel.doneButtonSubject.send("")

        // Assert
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(isShow)
    }

    func testTapOnCloseBarButton_WhenOpenPicker_ShouldHidePicker() {
        // Arrange
        XCTAssertTrue(viewModel.isHiddenCategoryPicker)
        viewModel.categoryViewSubject.send(.tap())
        XCTAssertFalse(viewModel.isHiddenCategoryPicker)

        // Act
        viewModel.closeBarButtonSubject.send(true)

        // Assert
        XCTAssertTrue(viewModel.isHiddenCategoryPicker)
    }
}
