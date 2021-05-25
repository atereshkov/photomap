//
//  MarkerCell.swift
//  PhotoMap
//
//  Created by yurykasper on 20.05.21.
//

import UIKit

final class MarkerCell: UITableViewCell {
    
    @IBOutlet private weak var markerImage: UIImageView!
    @IBOutlet private weak var markerDescription: UILabel!
    @IBOutlet private weak var markerDate: UILabel!
    @IBOutlet private weak var markerCategory: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    func configure(with marker: Marker) {
        markerImage.image = marker.image
        markerDescription.text = marker.description
        markerDate.text = marker.date.monthAndYear
        markerCategory.text = marker.category
    }
    
}
