//
//  MapPhotoViewModelTests.swift
//  PhotoMapTests
//
//  Created by Dzmitry Makarevich on 13.05.21.
//

import XCTest
import Combine
@testable import PhotoMap

class MapPhotoViewModelTests: XCTestCase {
    var viewModel: MapPhotoViewModelType!
    var coordinator: MapPhotoCoordinator!
    var diContainer: DIContainerType!
    var cancelBag: CancelBag!

    override func setUpWithError() throws {
        cancelBag = CancelBag()
        diContainer = DIContainerMock()
        coordinator = MapPhotoCoordinator(diContainer: diContainer)
        viewModel = MapPhotoViewModel(coordinator: coordinator, diContainer: diContainer)
    }

    override func tearDownWithError() throws {
        cancelBag = nil
        diContainer = nil
        viewModel = nil
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
}
