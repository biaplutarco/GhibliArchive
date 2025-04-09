//
//  MostRatedFilmCell.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 04/04/25.
//

import Combine
import UIKit

class MostRatedFilmCell: UICollectionViewCell, ReusableCell {
    static var reuseIdentifier = "MostRatedFilmCell"
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Views
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleJPLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.layer.opacity = 0.8
        return label
    }()
    
    private lazy var titleENLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    private lazy var ratingIcon: UIImageView = {
        let imageView = UIImageView(image: .rtScoreIcon)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.applyCardStyle()
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup(with: [
            cardView,
            posterImageView
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.cardView.layer.shadowPath = UIBezierPath(
                roundedRect: self.cardView.bounds,
                cornerRadius: self.cardView.layer.cornerRadius
            ).cgPath
        }
    }
    
    // MARK: - Configure
    
    func configure(with viewModel: MostRatedFilmViewModel) {
        viewModel.poster
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in self?.posterImageView.image = image }
            .store(in: &cancellables)
        titleJPLabel.text = viewModel.originalTitle
        titleENLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        ratingLabel.text = "\(viewModel.rtScore)%"
    }
}

// MARK: - ViewCodable

extension MostRatedFilmCell: ViewCodable {
    func setupConstraints() {
        let textStack = UIStackView(arrangedSubviews: [titleJPLabel, titleENLabel,         subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        let ratingStack = UIStackView(arrangedSubviews: [ratingIcon, ratingLabel])
        ratingStack.axis = .horizontal
        ratingStack.alignment = .leading
        ratingStack.spacing = 2
        
        let mainStack = UIStackView(arrangedSubviews: [textStack, ratingStack])
        mainStack.axis = .vertical
        mainStack.spacing = 8
        mainStack.alignment = .leading
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.4),

            mainStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor),

            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            cardView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
}
