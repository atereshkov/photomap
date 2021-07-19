//
//  CategoryViewModelTests.swift
//  PhotoMapTests
//
//  Created by yurykasper on 7.06.21.
//

import Combine
import Foundation
import XCTest
@testable import PhotoMap

class CategoryViewModelTests: XCTestCase {
    
    var viewModel: CategoryViewModelType!
    var diContainer: DIContainerType!
    var coordinator: CategoryCoordinator!
    var firestoreService: FirestoreServiceMock!
    var cancelBag: CancelBag!
    
    override func setUpWithError() throws {
        diContainer = DIContainerMock()
        let firestoreServiceDI: FirestoreServiceType = diContainer.resolve()
        firestoreService = firestoreServiceDI as? FirestoreServiceMock
        
        coordinator = CategoryCoordinator(diContainer: diContainer)
        viewModel = CategoryViewModel(coordinator: coordinator, diContainer: diContainer)
        
        cancelBag = CancelBag()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        diContainer = nil
        coordinator = nil
        firestoreService = nil
        cancelBag = nil
    }
    
    func testIfAuthorizedShouldGetCategoriesFromDatabase() {
        firestoreService.isEmptyCategories = false
        
        let expectation = XCTestExpectation()
        let indexPath = IndexPath(row: firestoreService.categories.count - 1, section: 0)
        
        viewModel.reloadDataSubject.sink(receiveValue: { _ in
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        wait(for: [expectation], timeout: 2)
        XCTAssertTrue(firestoreService.getCategoriesCalled)
        XCTAssertTrue(firestoreService.getCategoriesEndWithValues)
        XCTAssertEqual(firestoreService.categories.count, viewModel.getNumberOfRows())
        XCTAssertEqual(viewModel.getCategory(at: indexPath)?.id,
                       firestoreService.categories[at: firestoreService.categories.count - 1]?.id)
    }
    
    func testWhenSelectCategoryShouldChangeCategoryIsSelectedState() {
        firestoreService.isEmptyCategories = false
        
        let expectation = XCTestExpectation()
        let isSelected = false
        let indexPath = IndexPath(row: firestoreService.categories.count - 1, section: 0)
        
        viewModel.reloadDataSubject.sink(receiveValue: { _ in
            expectation.fulfill()
        })
        .store(in: cancelBag)

        wait(for: [expectation], timeout: 2)
        
        viewModel.didSelectRow(at: indexPath)
        XCTAssertEqual(viewModel.getCategory(at: indexPath)?.isSelected, isSelected)
    }
    
    func testWhenDoneButtonPressedCoordinatorHideCategoryScreen() {
        let expectation = XCTestExpectation()
        var doneButtonPressed = false
        
        coordinator.prepareForDismissSubject.sink(receiveValue: { _ in
            doneButtonPressed = true
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.doneButtonSubject.send(UIBarButtonItem())
        
        wait(for: [expectation], timeout: 2)
        XCTAssertTrue(doneButtonPressed)
    }
    
    func testWhenGettingCategoriesIndicatorShouldSpinning() {
        let expectation = XCTestExpectation()
        let expectedValues = [true, false]
        var results = [Bool]()
        var count = 0
        
        viewModel.loadingPublisher.sink(receiveValue: { isLoading in
            results.append(isLoading)
            count += 1
            if count == expectedValues.count {
                expectation.fulfill()
            }
        })
        .store(in: cancelBag)
        
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(expectedValues, results)
    }
}
