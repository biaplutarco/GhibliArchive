//
//  FilmsSeactionView.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 07/04/25.
//

//import UIKit
//
//final class FilmsSeactionView: UIView, ViewCodable {
//    private weak var collectionDelegate: UICollectionViewDelegate?
//
//    // MARK: - UI Components
//    
//    private lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = .boldSystemFont(ofSize: 16)
//        label.layer.opacity = 0.6
//        label.textColor = .label
//        label.text = "All films"
//        return label
//    }()
//    
//    private lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        layout.itemSize = UICollectionViewFlowLayout.automaticSize
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.delegate = collectionDelegate
//        return collectionView
//    }()
//
//    init(collectionDelegate: UICollectionViewDelegate) {
//        self.collectionDelegate = collectionDelegate
//        
//        super.init(frame: .zero)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func configure(with cell: ReusableCell) {
//        collectionView.register(ReusableCell.self, forCellWithReuseIdentifier: any ReusableCell.reuseIdentifier)
//        setup(with: [titleLabel, collectionView])
//    }
//    
//    // MARK: - Setup UI
//    
//    func setupConstraints() {
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//
//            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            collectionView.heightAnchor.constraint(equalToConstant: 200)
//        ])
//    }
//}
