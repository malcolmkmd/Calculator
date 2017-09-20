//
//  Reusable.swift
//  Calculator
//
//  Created by Malcolm Kumwenda on 2017/09/20.
//  Copyright © 2017 Byte Orbit. All rights reserved.
//

import UIKit
protocol ReusableView: class {}

extension ReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}

extension UITableViewCell: ReusableView { }
extension UICollectionViewCell: ReusableView { }
