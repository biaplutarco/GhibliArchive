//
//  FilmDetailsContentView.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import UIKit

final class FilmDetailsContentView: UIView {
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGreen
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var watchStatusButton: UIButton = {
        let button = UIButton()
        button.setTitle("Not seen yet", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var directorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .tertiaryLabel
        return label
    }()
    
    private let producerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .tertiaryLabel
        return label
    }()
    
    private lazy var charactersTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Characters"
        return label
    }()
    
    private lazy var charactersStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let infoStackView = UIStackView(arrangedSubviews: [ratingLabel, durationLabel, watchStatusButton])
        infoStackView.axis = .horizontal
        infoStackView.spacing = 16
        
        let mainStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            infoStackView,
            descriptionLabel,
            directorLabel,
            producerLabel,
            UIView(), // Spacer
            charactersTitleLabel,
            charactersStackView
        ])
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        return mainStackView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with film: Film) {
        titleLabel.text = film.title
        ratingLabel.text = "\(film.rtScore)%"
        durationLabel.text = film.runningTime
        descriptionLabel.text = film.description
        directorLabel.text = "Director: \(film.director)"
        producerLabel.text = "Producer: \(film.producer)"
        
        // Configure characters
        charactersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        film.people.forEach { character in
//            let characterView = UIImage()
//            characterView.configure(with: character)
//            charactersStackView.addArrangedSubview(characterView)
        }
        
        setup(with: [mainStackView])
    }
}

extension FilmDetailsView: ViewCodable {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}
