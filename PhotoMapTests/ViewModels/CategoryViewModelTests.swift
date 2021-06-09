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
        firestoreService.userId = "id"
        let categories = [
            PhotoMap.Category(id: "1", name: "default", color: "blue"),
            PhotoMap.Category(id: "2", name: "nature", color: "green"),
            PhotoMap.Category(id: "3", name: "friends", color: "orange")
        ]
        firestoreService.categories = categories
        
        let expectation = XCTestExpectation()
        let indexPath = IndexPath(row: categories.count - 1, section: 0)
        
        viewModel.reloadDataSubject.sink(receiveValue: { _ in
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        XCTAssertFalse(firestoreService.getCategoriesCalled)
        viewModel.viewDidLoadSubject.send()
        wait(for: [expectation], timeout: 2)
        XCTAssertTrue(firestoreService.getCategoriesCalled)
        XCTAssertTrue(firestoreService.getCategoriesEndWithValues)
        XCTAssertEqual(categories.count, viewModel.getNumberOfRows())
        XCTAssertEqual(viewModel.getCategory(at: indexPath)?.id, categories[at: categories.count - 1]?.id)
    }
    
    func testIfErrorOccuredThenCoordinatorShowErrorAlert() {
        firestoreService.userId = "id"
        firestoreService.error = .custom("error occured")
        
        let expectation = XCTestExpectation()
        var showAlertCalled = false
        
        coordinator.showErrorAlertSubject.sink(receiveValue: { _ in
            showAlertCalled = true
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        XCTAssertFalse(firestoreService.getCategoriesCalled)
        viewModel.viewDidLoadSubject.send()
        wait(for: [expectation], timeout: 2)
        XCTAssertTrue(firestoreService.getCategoriesCalled)
        XCTAssertTrue(showAlertCalled)
    }
    
    func testWhenSelectCategoryShouldChangeCategoryIsSelectedState() {
        firestoreService.userId = "id"
        let categories = [
            PhotoMap.Category(id: "1", name: "default", color: "blue"),
            PhotoMap.Category(id: "2", name: "nature", color: "green"),
            PhotoMap.Category(id: "3", name: "friends", color: "orange")
        ]
        firestoreService.categories = categories
        
        let expectation = XCTestExpectation()
        let isSelected = false
        let indexPath = IndexPath(row: categories.count - 1, section: 0)
        
        viewModel.reloadDataSubject.sink(receiveValue: { _ in
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.viewDidLoadSubject.send()
        wait(for: [expectation], timeout: 2)
        
        viewModel.didSelectRow(at: indexPath)
        XCTAssertEqual(viewModel.getCategory(at: indexPath)?.isSelected, isSelected)
    }
    
    func testWhenDoneButtonPressedCoordinatorHideCategoryScreen() {
        let expectation = XCTestExpectation()
        var doneButtonPressed = false
        
        coordinator.doneButtonSubject.sink(receiveValue: { _ in
            doneButtonPressed = true
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.doneButtonSubject.send(UIBarButtonItem())
        
        wait(for: [expectation], timeout: 2)
        XCTAssertTrue(doneButtonPressed)
    }
}
