//
//  PhotoMarkerView.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6/10/21.
//

import MapKit
import Combine

class PhotoMarkerView: MKMarkerAnnotationView {
    private(set) var loadImageSubject = PassthroughSubject<UIImage, Never>()
    private let cancelBag = CancelBag()
    private(set) var isLoadImage = false

    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.backgroundColor = Asset.activityIndicatorBackgroundColor.color
        activityIndicator.style = .medium
        activityIndicator.tag = 1
        activityIndicator.color = Asset.activityIndicatorIndicatorColor.color
        activityIndicator.layer.zPosition = 10

        return activityIndicator
    }()

    override var annotation: MKAnnotation? {
        willSet {
            guard let photo = newValue as? PhotoAnnotation else { return }

            canShowCallout = true

            titleVisibility = .hidden
            subtitleVisibility = .hidden

            rightCalloutAccessoryView = activityIndicator
            activityIndicator.startAnimating()

            if let color = photo.category?.color {
                markerTintColor = UIColor(hex: color)
            }
            if let name = photo.category?.name, let letter = name.first {
                glyphText = String(letter)
            }
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        bind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        loadImageSubject
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] image in
                let photoButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                         size: CGSize(width: 68, height: 48)))
                photoButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 5)
                photoButton.setImage(image, for: .normal)

                self?.activityIndicator.stopAnimating()
                self?.rightCalloutAccessoryView = photoButton
                self?.isLoadImage = true
            })
            .store(in: cancelBag)
    }
}
