//
//  PhotoMarkerView.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6/10/21.
//

import MapKit
import Combine

class PhotoMarkerView: MKMarkerAnnotationView {
    private let cancelBag = CancelBag()
    @Published var detailImage: UIImage?

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.backgroundColor = Asset.activityIndicatorBackgroundColor.color
        activityIndicator.style = .medium
        activityIndicator.tag = 1
        activityIndicator.color = Asset.activityIndicatorIndicatorColor.color
        activityIndicator.layer.zPosition = 10

        return activityIndicator
    }()

    override func prepareForDisplay() {
        super.prepareForDisplay()

        guard let photo = annotation as? PhotoAnnotation else { return }

        canShowCallout = true
        displayPriority = .defaultHigh

        titleVisibility = .hidden
        subtitleVisibility = .hidden

        setDetail(by: detailImage)

        if let color = photo.category?.color {
            markerTintColor = UIColor(hex: color)
        }
        if let name = photo.category?.name, let letter = name.first {
            glyphText = String(letter)
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        clusteringIdentifier = PhotoClusterView.className
        bind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind() {
        $detailImage
            .filter { $0 != nil }
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] image in
                self?.setDetail(by: image)
            })
            .store(in: cancelBag)
    }

    private func setDetail(by image: UIImage?) {
        if let image = image {
            let button = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                     size: CGSize(width: 60, height: 42)))
            button.setImage(image, for: .normal)

            activityIndicator.stopAnimating()
            rightCalloutAccessoryView = button
        } else {
            rightCalloutAccessoryView = activityIndicator
            activityIndicator.startAnimating()
        }
    }
}
