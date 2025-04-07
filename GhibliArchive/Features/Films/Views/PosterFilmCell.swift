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
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 6
        return imageView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup

    private func setupViews() {
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 125),
            imageView.heightAnchor.constraint(equalToConstant: 175)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // MARK: - Configure
    func configure(with viewModel: MostRatedFilmViewModel) {
        viewModel.poster
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in self?.imageView.image = image }
            .store(in: &cancellables)
    }
}
