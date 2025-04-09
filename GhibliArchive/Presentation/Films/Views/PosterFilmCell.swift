//
//  PosterFilmCell.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 06/04/25.
//

import Combine
import UIKit

class PosterFilmCell: UICollectionViewCell, ReusableCell {
    static var reuseIdentifier = "PosterFilmCell"
    private var cancellables: Set<AnyCancellable> = []
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        return imageView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(with: [imageView])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "placeholder")
    }
    
    // MARK: - Configure
    func configure(with viewModel: PosterFilmViewModel) {
        viewModel.poster
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in self?.imageView.image = image }
            .store(in: &cancellables)
    }
}

// MARK: - ViewCodable

extension PosterFilmCell: ViewCodable {
    func setupConstraints() {
        imageView.fillToSuperview()
    }
}
