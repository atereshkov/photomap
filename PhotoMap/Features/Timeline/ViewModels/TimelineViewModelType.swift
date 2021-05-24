//
//  TimelineViewModelType.swift
//  PhotoMap
//
//  Created by yurykasper on 20.05.21.
//

import UIKit
import Combine

protocol TimelineViewModelTypeInput {
    func getMarker(at indexPath: IndexPath) -> Marker?
    func setTitle(for: Int) -> String?
}

protocol TimelineViewModelTypeOutput {
    var numberOfSections: Int { get }
    var numberOfRows: Int { get }
}

protocol TimelineViewModelType: TimelineViewModelTypeInput, TimelineViewModelTypeOutput {}
