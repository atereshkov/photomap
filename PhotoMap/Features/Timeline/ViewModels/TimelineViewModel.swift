//
//  TimelineViewModel.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit
import Combine

class TimelineViewModel: TimelineViewModelType {
    
    // MARK: - Variables
    private let coordinator: TimelineCoordinator
    var numberOfSections = 2
    var headerTitles = ["Novermber 2015", "October 2015"]
    var numberOfRows: Int {
        return headerTitles.count * 3
    }
    
    init(coordinator: TimelineCoordinator) {
        self.coordinator = coordinator
    }
    
}
