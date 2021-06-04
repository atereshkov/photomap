//
//  TimelineCoordinatorMock.swift
//  PhotoMapTests
//
//  Created by yurykasper on 27.05.21.
//

import UIKit
@testable import PhotoMap

class TimelineCoordinatorMock: TimelineCoordinator {
    
    var showErrorCalled = false
    
    override func showError(error: GeneralErrorType) {
        showErrorCalled = true
    }
}
