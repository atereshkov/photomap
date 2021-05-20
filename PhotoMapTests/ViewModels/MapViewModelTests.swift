//
//  MapViewModelTests.swift
//  PhotoMapTests
//
//  Created by Dzmitry Makarevich on 4/27/21.
//

import XCTest
import Combine
import Swinject
@testable import PhotoMap

class MapViewModelTests: XCTestCase {
    var viewModel: MapViewModelType!
    var coordinator: MapCoordinator!
    var diContainer: DIContainerType!
    var cancelBag: CancelBag!
    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        cancelBag = CancelBag()
        expectation = XCTestExpectation()
        diContainer = DIContainerMock()
        coordinator = MapCoordinator(diContainer: diContainer)
        viewModel = MapViewModel(coordinator: coordinator, diContainer: diContainer)
    }

    override func tearDownWithError() throws {
        cancelBag = nil
        expectation = nil
        diContainer = nil
        viewModel = nil
    }

    func testTapOnMap_FolowModeOn_ShouldOnDiscoveryMode() {
        viewModel.enableDiscoveryModeSubject.send(.tap())

        XCTAssertFalse(viewModel.isFollowModeOn)
    }

    func testTapOnPhotoButton_FolowModeOn_ShouldOnDiscoveryMode() {
        viewModel.photoButtonSubject.send(UIControl())

        XCTAssertFalse(viewModel.isFollowModeOn)
    }

    func testTapOnCategoryButton_FolowModeOn_ShouldOnDiscoveryMode() {
        viewModel.categoryButtonSubject.send(UIControl())

        XCTAssertFalse(viewModel.isFollowModeOn)
    }

    func testTapOnPhotoButton_ShouldShowPhotoAlert() {
        // Arrange
        var isShow = false
        let expectation = self.expectation(description: "Photo Alert is load")
        
        // Act
        coordinator.showPhotoMenuAlertSubject
            .sink { _ in
                isShow = true
                expectation.fulfill()
            }
            .store(in: cancelBag)
        
        viewModel.photoButtonSubject.send(UIControl())
        wait(for: [expectation], timeout: 0.1)

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
