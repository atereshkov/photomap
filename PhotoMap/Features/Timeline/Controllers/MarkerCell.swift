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
    
    private let cancelBag = CancelBag()
    var viewModel: TimelineCellViewModel? {
        didSet {
            bind()
        }
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        viewModel.$image
            .assign(to: \.image, on: markerImage)
            .store(in: cancelBag)
        
        viewModel.$description
            .assign(to: \.text, on: markerDescription)
            .store(in: cancelBag)
        
        viewModel.$date
            .assign(to: \.text, on: markerDate)
            .store(in: cancelBag)
        
        viewModel.$category
            .assign(to: \.text, on: markerCategory)
            .store(in: cancelBag)
        
        viewModel.loadingPublisher.sink(receiveValue: { [weak self] isLoading in
            isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        })
        .store(in: cancelBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        viewModel = nil
    }
}
