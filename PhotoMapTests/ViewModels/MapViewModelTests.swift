//
//  MapViewModelTests.swift
//  PhotoMapTests
//
//  Created by Dzmitry Makarevich on 4/27/21.
//

import XCTest
import Combine
@testable import PhotoMap

class MapViewModelTests: XCTestCase {
    var viewModel: MapViewModelType!
    var coordinator: MapCoordinator!
    var diContainer: DIContainerType!
    var cancelBag: CancelBag!

    override func setUpWithError() throws {
        cancelBag = CancelBag()
        diContainer = DIContainerMock()
        coordinator = MapCoordinator(diContainer: diContainer)
        viewModel = MapViewModel(coordinator: coordinator, diContainer: diContainer)
    }

    override func tearDownWithError() throws {
        cancelBag = nil
        diContainer = nil
        viewModel = nil
    }

    func testTapOnMap_FolowModeOn_ShouldOnDiscoveryMode() {
        XCTAssertTrue(viewModel.isFollowModeOn)

        viewModel.enableDiscoveryModeSubject.send(.tap())

        XCTAssertFalse(viewModel.isFollowModeOn)
    }

    func testTapOnPhotoButton_FolowModeOn_ShouldOnDiscoveryMode() {
        XCTAssertTrue(viewModel.isFollowModeOn)

        viewModel.photoButtonSubject.send(UIControl())

        XCTAssertFalse(viewModel.isFollowModeOn)
    }

    func testTapOnCategoryButton_FolowModeOn_ShouldOnDiscoveryMode() {
        XCTAssertTrue(viewModel.isFollowModeOn)

        viewModel.categoryButtonSubject.send(UIControl())

        XCTAssertFalse(viewModel.isFollowModeOn)
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
        
        viewModel.photoButtonSubject.send(UIControl())

        // Assert
        XCTAssertTrue(isShow)
    }

    func testTapOnNavigationButton_ShouldSwitchMode() {
        XCTAssertTrue(viewModel.isFollowModeOn)

        viewModel.navigationButtonSubject.send(UIControl())
        XCTAssertFalse(viewModel.isFollowModeOn)
        
        viewModel.navigationButtonSubject.send(UIControl())
        XCTAssertTrue(viewModel.isFollowModeOn)
    }
}
