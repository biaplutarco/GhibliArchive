//
//  UICollectionView+ItemSize.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import UIKit

extension UICollectionView {
    func itemSize(itemsPerRow: CGFloat, spacing: CGFloat = 16, heightMultiplier: CGFloat = 1.4) -> CGSize {
        let totalSpacing = spacing * (itemsPerRow + 1)
        let width = (bounds.width - totalSpacing) / itemsPerRow
        return CGSize(width: width, height: width * heightMultiplier)
    }
}
