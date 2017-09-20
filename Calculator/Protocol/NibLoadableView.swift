//
//  NibLoadable.swift
//  Calculator
//
//  Created by Malcolm Kumwenda on 2017/09/20.
//  Copyright © 2017 Byte Orbit. All rights reserved.
//

import UIKit

protocol NibLoadableView: class { }

extension NibLoadableView {
    
    static var nibName: String {
        return String(describing: self)
    }
    
}

extension UITableViewCell: NibLoadableView { }
extension UICollectionViewCell: NibLoadableView { }
