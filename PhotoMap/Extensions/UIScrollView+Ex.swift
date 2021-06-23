//
//  UIScrollView+Ex.swift
//  PhotoMap
//
//  Created by yurykasper on 23.06.21.
//

import UIKit

extension UIScrollView {
    func zoomRect(for scale: CGFloat, in imageView: UIImageView, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width / scale
        let newCenter = self.convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}
