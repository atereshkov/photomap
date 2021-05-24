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
    private var markers = [
        Marker(image: UIImage(systemName: "photo")!, description: "first img", date: Date(), category: "Default"),
        Marker(image: UIImage(systemName: "photo")!, description: "second img", date: Date(), category: "Friends")
    ]
    
    var numberOfSections: Int {
        return markers.count
    }
    
    private var headerTitles = ["Novermber 2015", "October 2015"]
    var numberOfRows: Int {
        return headerTitles.count
    }
    
    // MARK: - Lifecycle
    init(coordinator: TimelineCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Helpers
    func getMarker(at indexPath: IndexPath) -> Marker? {
        return markers[at: indexPath.row]
    }
    
    func setTitle(for section: Int) -> String? {
        return headerTitles[at: section]
    }
    
}
