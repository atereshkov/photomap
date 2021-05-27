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
        let photo = Photo(image: UIImage())
        viewModel = MapPhotoViewModel(coordinator: coordinator, diContainer: diContainer, photo: photo)
    }

    override func tearDownWithError() throws {
        cancelBag = nil
        diContainer = nil
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

    func testDoneButtonTitle_ShouldBeEqual() {
        XCTAssertEqual(viewModel.doneButtonTitle, L10n.Main.MapPhoto.Button.Title.done)
    }

    func testCancelButtonTitle_ShouldBeEqual() {
        XCTAssertEqual(viewModel.cancelButtonTitle, L10n.Main.MapPhoto.Button.Title.cancel)
    }

    func testCloseCategoryPickerViewButtonTitle_ShouldBeEqual() {
        XCTAssertEqual(viewModel.closeCategoryPickerViewButtonTitle, L10n.Main.MapPhoto.Button.Title.close)
    }
}
