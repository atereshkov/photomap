//
//  UIColor+Ex.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6.05.21.
//

import UIKit

extension UIColor {
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        let red, green, blue: CGFloat
        var hexColor = hex

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            hexColor = String(hex[start...])
        }

        if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                red = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                blue = CGFloat(hexNumber & 0x0000ff) / 255

                self.init(red: red, green: green, blue: blue, alpha: alpha)
                return
            }
        }

        return nil
    }

    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0

        return String(format: "#%06x", rgb)
    }
}
