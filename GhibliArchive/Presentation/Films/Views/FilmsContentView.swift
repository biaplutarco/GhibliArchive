//
//  FilmsContentView.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 07/04/25.
//

import UIKit

protocol FilmsContentViewDelegate: AnyObject {
    func setMostRatedFilmsDataSource(to collectionView: UICollectionView)
    func setAllFilmsDataSource(to collectionView: UICollectionView)
    func collectionType(_ type: FilmsContentView.CollectionType, didSelectItemAt indexPath: IndexPath)
}

final class FilmsContentView: UIView {
    enum CollectionType {
        case mostRated
        case allFilms
    }
    
    weak var delegate: FilmsContentViewDelegate?
    
    // MARK: - UI Components
    
    private lazy var mostRatedFilmsLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.layer.opacity = 0.6
        label.textColor = .label
        label.text = "Most rated"
        return label
    }()
    
    private lazy var allFilmsLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.layer.opacity = 0.6
        label.textColor = .label
        label.text = "All films"
        return label
    }()
    
    private lazy var mostRatedFilmsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MostRatedFilmCell.self, forCellWithReuseIdentifier: MostRatedFilmCell.reuseIdentifier)
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var allFilmsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PosterFilmCell.self, forCellWithReuseIdentifier: PosterFilmCell.reuseIdentifier)
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup

    func configure() {
        setup(with: [
            mostRatedFilmsLabel,
            mostRatedFilmsCollectionView,
            allFilmsLabel,
            allFilmsCollectionView
        ])
        
        setupDataSourcer()
    }
    
    // MARK: - DataSource
    
    private func setupDataSourcer() {
        delegate?.setMostRatedFilmsDataSource(to: mostRatedFilmsCollectionView)
        delegate?.setAllFilmsDataSource(to: allFilmsCollectionView)
    }

    private func calculateItemSize(for collectionView: UICollectionView, itemsPerRow: CGFloat, spacing: CGFloat = 16, heightMultiplier: CGFloat = 1.4) -> CGSize {
        let totalSpacing = spacing * (itemsPerRow + 1)
        let width = (collectionView.bounds.width - totalSpacing) / itemsPerRow
        return CGSize(width: width, height: width * heightMultiplier)
    }
}

extension FilmsContentView: ViewCodable {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mostRatedFilmsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mostRatedFilmsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            mostRatedFilmsCollectionView.topAnchor.constraint(equalTo: mostRatedFilmsLabel.bottomAnchor),
            mostRatedFilmsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mostRatedFilmsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mostRatedFilmsCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            allFilmsLabel.topAnchor.constraint(equalTo: mostRatedFilmsCollectionView.bottomAnchor, constant: 8),
            allFilmsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            allFilmsCollectionView.topAnchor.constraint(equalTo: allFilmsLabel.bottomAnchor),
            allFilmsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            allFilmsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            allFilmsCollectionView.heightAnchor.constraint(equalToConstant: 200),
            allFilmsCollectionView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: 16)
        ])
    }
}

// MARK: - UICollectionViewDelegate

extension FilmsContentView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == allFilmsCollectionView {
            return .init(top: 0, left: 16, bottom: 0, right: 16)
        } else {
            return .init(top: 0, left: 8, bottom: 0, right: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard collectionView == allFilmsCollectionView else {
            return .zero
        }
        return collectionView.itemSize(itemsPerRow: 2.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == allFilmsCollectionView {
            delegate?.collectionType(.allFilms, didSelectItemAt: indexPath)
        } else {
            delegate?.collectionType(.mostRated, didSelectItemAt: indexPath)
        }
    }
}
