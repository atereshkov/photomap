//
//  PhotoMarkerView.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6/10/21.
//

import MapKit

class PhotoMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let photo = newValue as? PhotoAnnotation else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: 0, y: 5)
            
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 48, height: 48)))
            mapsButton.setBackgroundImage(UIImage(systemName: "photo"), for: .normal)
            rightCalloutAccessoryView = mapsButton
            if let color = photo.category?.color {
                markerTintColor = UIColor(hex: color)
            }
            if let name = photo.category?.name, let letter = name.first {
                glyphText = String(letter)
            }
        }
    }
}
