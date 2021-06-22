//
//  PhotoClusterView.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6/22/21.
//

import MapKit

class PhotoClusterView: MKAnnotationView {
    private let rect = CGRect(x: 0, y: 0, width: 40, height: 40)

    override var annotation: MKAnnotation? {
        didSet {
            guard let cluster = annotation as? MKClusterAnnotation else { return }

            displayPriority = .defaultHigh
            image = drawCircle(for: cluster.memberAnnotations)
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        centerOffset = CGPoint(x: 0, y: -10)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func drawCircle(for annotations: [MKAnnotation]) -> UIImage {
        UIGraphicsImageRenderer(size: rect.size)
            .image { _ in
                UIColor(red: 0, green: 10 / 255.0, blue: 1, alpha: 1.0).setFill()
                UIBezierPath(ovalIn: rect).fill()
                
                let piePath = UIBezierPath()
                piePath.addLine(to: CGPoint(x: 20, y: 20))
                piePath.close()
                piePath.fill()
                
                UIColor.white.setFill()
                UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()
                
                String(annotations.count).drawForCluster(in: rect)
            }
    }
}
