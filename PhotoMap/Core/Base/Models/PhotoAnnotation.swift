//
//  PhotoAnnotation.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6/10/21.
//

import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
    let title: String?
    let date: String?
    let category: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, date: String?, category: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.date = date
        self.category = category
        self.coordinate = coordinate
        
        super.init()
    }
    
    init(photo: ReceivePhoto) {
        self.title = photo.description
        self.date = photo.date.toString
        self.category = photo.category
        self.coordinate = photo.toMapCoordinates()
        
        super.init()
    }
    
    var subtitle: String? {
        return date
    }
}
