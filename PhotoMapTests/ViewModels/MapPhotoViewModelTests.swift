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
    var service: FirestoreServiceMock!
    var cancelBag: CancelBag!

    override func setUpWithError() throws {
        cancelBag = CancelBag()
        diContainer = DIContainerMock()
        let serviceType: FirestoreServiceType = diContainer.resolve()
        service = serviceType as? FirestoreServiceMock
        coordinator = MapPhotoCoordinator(diContainer: diContainer)
        let photo = Photo(image: UIImage(), coordinate: CLLocationCoordinate2D())
        viewModel = MapPhotoViewModel(coordinator: coordinator, diContainer: diContainer, photo: photo)
    }

    override func tearDownWithError() throws {
        cancelBag = nil
        diContainer = nil
        service = nil
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

    func testTapOnCategoryView_ShouldShowCategoryPickerView() {
        // Arrange
        XCTAssertTrue(viewModel.isHiddenCategoryPicker)

        // Act
        viewModel.categoryViewSubject.send(.tap())

        // Assert
        XCTAssertFalse(viewModel.isHiddenCategoryPicker)
    }

    func testTapOnloseBarButton_ShouldShowCategoryPickerView() {
        // Arrange
        viewModel.categoryViewSubject.send(.tap())
        XCTAssertFalse(viewModel.isHiddenCategoryPicker)

        // Act        
        viewModel.closeBarButtonSubject.send(UIBarButtonItem())

        // Assert
        XCTAssertTrue(viewModel.isHiddenCategoryPicker)
    }

    func testCategoryPublisher_ShouldBeNotNil() {
        XCTAssertNotNil(viewModel.categoryPublisher)
    }

    func testPhotoPublisher_ShouldBeNotNil() {
        XCTAssertNotNil(viewModel.photoPublisher)
    }
}
