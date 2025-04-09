//
//  UIView+CardStyle.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Foundation

import UIKit

extension UIView {    
    func applyCardStyle() {
        layer.cornerRadius = 8
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .init(width: 0, height: 4)
        layer.masksToBounds = false
        backgroundColor = .white
    }
}
