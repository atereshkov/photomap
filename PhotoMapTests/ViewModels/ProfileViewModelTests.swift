//
//  ProfileViewModelTests.swift
//  PhotoMapTests
//
//  Created by yurykasper on 1.07.21.
//

import UIKit
import XCTest
@testable import PhotoMap

class ProfileViewModelTests: XCTestCase {
    var viewModel: ProfileViewModelType!
    var diContainer: DIContainerType!
    var coordinator: ProfileCoordinator!
    var firestoreService: FirestoreServiceMock!
    var cancelBag: CancelBag!
    
    override func setUpWithError() throws {
        diContainer = DIContainerMock()
        coordinator = ProfileCoordinator(diContainer: diContainer)
        let firestoreServiceDI: FirestoreServiceType = diContainer.resolve()
        firestoreService = firestoreServiceDI as? FirestoreServiceMock
        firestoreService.userId = "id"
        viewModel = ProfileViewModel(coordinator: coordinator, diContainer: diContainer)
        cancelBag = CancelBag()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        diContainer = nil
        firestoreService = nil
        coordinator = nil
        cancelBag = nil
    }
    
    func testOne() {
        let currentUser = User(name: "tester", email: "tester@gmail.com")
        firestoreService.currentUser = currentUser
        
        let expectation = XCTestExpectation()
        
        viewModel.viewDidLoadSubject.sink(receiveValue: { _ in
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.viewDidLoadSubject.send()
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(currentUser.email, viewModel.email)
        XCTAssertEqual(currentUser.name, viewModel.username)
    }
    
    func testTwo() {
        guard let viewModel = viewModel as? ProfileViewModel else { return }
        firestoreService.error = .custom("error")
        
        let expectation = XCTestExpectation()
        var showErrorAlertCalled = false
        
        coordinator.showErrorSubject.sink(receiveValue: { _ in
            showErrorAlertCalled = true
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.viewDidLoadSubject.send()
        wait(for: [expectation], timeout: 2)
        
        XCTAssertTrue(showErrorAlertCalled)
    }
    
    func testThree() {
        let currentUser = User(name: "tester", email: "tester@gmail.com")
        firestoreService.currentUser = currentUser
        
        let expectation = XCTestExpectation()
        let expectedValues = [false, true, false]
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
        
        viewModel.viewDidLoadSubject.send()
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(expectedValues, results)
    }
    
    func testFour() {
        let currentUser = User(name: "tester", email: "tester@gmail.com")
        firestoreService.currentUser = currentUser
        
        let expectation = XCTestExpectation()
        var logoutButtonTapped = false
        
        coordinator.logoutButtonSubject.sink(receiveValue: { _ in
            logoutButtonTapped = true
            expectation.fulfill()
        })
        .store(in: cancelBag)
        
        viewModel.viewDidLoadSubject.send()
        viewModel.logoutButtonSubject.send(UIBarButtonItem())
        wait(for: [expectation], timeout: 2)
        
        XCTAssertTrue(logoutButtonTapped)
    }
}
