//
//  ViewCodable.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 07/04/25.
//

import UIKit

protocol ViewCodable {
    func setup(with views : [UIView])
    func addToHierarchy(_ views : [UIView])
    func setupConstraints()
    func additionalSetup()
}

extension ViewCodable {
    func setup(with views : [UIView]) {
        addToHierarchy(views)
        additionalSetup()
        setupConstraints()
    }
    
    func additionalSetup() { }
    
    private func add(_ views: [UIView], to parentView: UIView) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            parentView.addSubview($0)
        }
    }
}

//MARK: - UI extensions

extension ViewCodable where Self: UIView {
    func addToHierarchy(_ views: [UIView]) {
        add(views, to: self)
    }
}

extension ViewCodable where Self: UIViewController {
    func addToHierarchy(_ views: [UIView]) {
        add(views, to: view)
    }
}

