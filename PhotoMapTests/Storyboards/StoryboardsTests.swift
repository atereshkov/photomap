//
//  StoryboardsTests.swift
//  PhotoMapTests
//
//  Created by Dzmitry Makarevich on 5/20/21.
//

import XCTest
@testable import PhotoMap

class StoryboardsTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testMapViewController() {
        let vc = StoryboardScene.Map.mapViewController.instantiate()
        XCTAssertNotNil(vc)
    }

    func testMapPhotoViewController() {
        let vc = StoryboardScene.MapPhoto.mapPhotoViewController.instantiate()
        XCTAssertNotNil(vc)
    }

    func testSignInViewController() {
        let vc = StoryboardScene.Authentication.signInViewController.instantiate()
        XCTAssertNotNil(vc)
    }

    func testSignUpViewController() {
        let vc = StoryboardScene.Authentication.signUpViewController.instantiate()
        XCTAssertNotNil(vc)
    }

    func testInitialViewController() {
        let vc = StoryboardScene.Initial.initialViewController.instantiate()
        XCTAssertNotNil(vc)
    }
}
