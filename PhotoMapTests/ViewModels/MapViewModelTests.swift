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
    var diContainer: DIContainerType!
    var cancelBag: CancelBag!
    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        cancelBag = CancelBag()
        expectation = XCTestExpectation()
        diContainer = DIContainerMock()
        viewModel = MapViewModel(coordinator: MapCoordinator(diContainer: diContainer),
                                 diContainer: diContainer)
    }

    override func tearDownWithError() throws {
        cancelBag = nil
        expectation = nil
        diContainer = nil
        viewModel = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
