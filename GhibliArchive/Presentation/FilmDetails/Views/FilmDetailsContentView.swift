//
//  FilmDetailsContentView.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Combine
import UIKit

// MARK: - Delegate

protocol FilmDetailsContentViewDelegate: AnyObject {
    func didTapFavorite()
}

// MARK: - Class

final class FilmDetailsContentView: UIView {
    private var cancellables: Set<AnyCancellable> = []
    private var isFavorite: Bool = false
    
    weak var delegate: FilmDetailsContentViewDelegate?
    
    // MARK: - UI Components
    private let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var originalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGreen
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    private lazy var directorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let producerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.applyCardStyle()
        return view
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            originalTitleLabel,
            titleLabel,
            subtitleLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var creatorsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            directorLabel,
            producerLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var cardStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerStackView,
            descriptionLabel,
            creatorsStackView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 18
        return stackView
    }()
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    func configure(with viewModel: FilmDetailsContentViewModel) {
        viewModel.banner
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in self?.bannerImageView.image = image }
            .store(in: &cancellables)
        
        originalTitleLabel.text = viewModel.originalTitle
        titleLabel.text = viewModel.title
        ratingLabel.text = viewModel.rtScore
        subtitleLabel.text = viewModel.subtitle
        descriptionLabel.text = viewModel.description
        directorLabel.text = viewModel.director
        producerLabel.text = viewModel.producer
        isFavorite = viewModel.isFavorite
        configureFavoriteStyle(isFavorite)
        
        setup(with: [
            bannerImageView,
            cardView,
            favoriteButton
        ])
    }
    
    private func configureFavoriteStyle(_ isFavorite: Bool) {
        favoriteButton.setTitle(isFavorite ? "Unfavorite" : "Favorite", for: .normal)
        favoriteButton.setTitleColor(isFavorite ? .ghibliBlue : .white, for: .normal)
        favoriteButton.backgroundColor = isFavorite ? .ghibliGray : .ghibliBlue
        favoriteButton.layer.borderColor = UIColor.ghibliBlue.cgColor
    }
    
    // MARK: - Actions
    
    @objc private func didTapFavorite() {
        delegate?.didTapFavorite()
        isFavorite.toggle()
        configureFavoriteStyle(isFavorite)
    }
}

// MARK: - ViewCodable

extension FilmDetailsContentView: ViewCodable {
    func setupConstraints() {
        cardView.addSubview(cardStackView)
        
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bannerImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            
            cardView.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: -32),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            cardStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 28),
            cardStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            cardStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            cardStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -32),
            
            favoriteButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            favoriteButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -22),
            favoriteButton.widthAnchor.constraint(equalToConstant: 84),

        ])
    }
    
    func additionalSetup() {
        backgroundColor = .white
    }
}
