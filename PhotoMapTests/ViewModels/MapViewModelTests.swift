//
//  MapViewModelTests.swift
//  PhotoMapTests
//
//  Created by Dzmitry Makarevich on 4/27/21.
//

import XCTest
import Combine
import CoreLocation
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
        coordinator = nil
        viewModel = nil
    }

    func testTabTitle_Title_ShouldEqual() {
        XCTAssertEqual(viewModel.tabTitle, L10n.Main.TabBar.Map.title)
    }

    func testModeButtonColor_ShouldEqual() {
        // Arrange
        XCTAssertEqual(viewModel.modeButtonCollor, Asset.followModeColor.color)

        // Act
        viewModel.navigationButtonSubject.send(UIControl())

        // Assert
        XCTAssertEqual(viewModel.modeButtonCollor, Asset.discoverModeColor.color)
    }

    func testIsShowUserLocation_EnableLocation_ShouldBeTrue() {
        // Arrange
        var isEqual = false
        XCTAssertFalse(viewModel.isShowUserLocation)
        let locationService: LocationServiceType = diContainer.resolve()
        guard let mockService = locationService as? LocationServiceMock else {
            XCTAssertNotNil(nil, "Typecast Error!")
            return
        }

        // Act
        mockService.status
            .sink { status in
                isEqual = status == .authorizedWhenInUse
            }
            .store(in: cancelBag)

        mockService.enableService()

        // Assert
        XCTAssertTrue(viewModel.isShowUserLocation)
        XCTAssertTrue(isEqual)
    }

    func  testIsShowUserLocation_DisableLocation_ShouldBeFalse() {
        // Arrange
        var isEqual = false
        XCTAssertFalse(viewModel.isShowUserLocation)
        let locationService: LocationServiceType = diContainer.resolve()
        guard let mockService = locationService as? LocationServiceMock else {
            XCTAssertNotNil(nil, "Typecast Error!")
            return
        }
        
        // Act
        mockService.status
            .sink { status in
                isEqual = status == .denied
            }
            .store(in: cancelBag)

        mockService.enableService()
        mockService.disableService()

        // Assert
        XCTAssertFalse(viewModel.isShowUserLocation)
        XCTAssertTrue(isEqual)
    }

    func testRegion_ShouldBeNotNil() {
        XCTAssertNotNil(viewModel.region)
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

    func testCategoryButtonPublisher_WhenTapped_ShouldShowCategoryFilter() {
        // Arrange
        var isShow = false
        coordinator.showMapPopupSubject
            .sink(receiveValue: { _ in
                isShow = true
            })
            .store(in: cancelBag)

        // Act
        viewModel.categoryButtonSubject.send(UIControl())

        // Assert
        XCTAssertTrue(isShow)
    }
}
