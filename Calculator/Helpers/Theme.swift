//
//  Theme.swift
//  Calculator
//
//  Created by Malcolm Kumwenda on 2017/09/18.
//  Copyright © 2017 Byte Orbit. All rights reserved.
//

import UIKit.UIColor

enum Theme {
    case white, blue, bg, red
    
    var color: UIColor {
        switch self {
        case .white: return UIColor(hexString: "#F4F5F9")
        case .blue: return UIColor(hexString: "#927F8A")
        case .bg: return UIColor(hexString: "#35394C")
        case .red: return UIColor(hexString: "#EA3E49")
        }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
