//
//  UIView + Extension.swift
//  RssReaderApp
//
//  Created by Borna Ungar on 23.12.2021..
//

import Foundation
import UIKit
extension UIView {
    
    func addSubviews(views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
