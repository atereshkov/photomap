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
    
    func configure() {
        markerImage.image = UIImage(systemName: "photo")
        markerDescription.text = "My best friend show me his new Macbook Pro with M1"
        markerDate.text = "11-16-15"
        markerCategory.text = "FRIENDS"
    }
    
}
