//
//  MarkerCell.swift
//  PhotoMap
//
//  Created by yurykasper on 20.05.21.
//

import Combine
import UIKit

final class MarkerCell: UITableViewCell {
    @IBOutlet private weak var markerImage: UIImageView!
    @IBOutlet private weak var markerDescription: UILabel!
    @IBOutlet private weak var markerDate: UILabel!
    @IBOutlet private weak var markerCategory: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: TimelineCellViewModel?
    private let cancelBag = CancelBag()
    
    func configure(with marker: Marker) {
        bind()
        if let url = marker.imageURL, let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
            markerImage.image = image
        } else {
            viewModel?.downloadImage(for: marker)
        }
        markerDescription.text = marker.description
        markerDate.text = marker.date.shortDate
        markerCategory.text = marker.category
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        viewModel.loadingPublisher.sink(receiveValue: { [weak self] isLoading in
            isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        })
        .store(in: cancelBag)
        
        viewModel.urlSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] url in
                guard let url = url, let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) else {
                    self?.markerImage.image = UIImage(systemName: "photo")
                    return
                }
                self?.markerImage.image = image
            })
            .store(in: cancelBag)
    }
}
