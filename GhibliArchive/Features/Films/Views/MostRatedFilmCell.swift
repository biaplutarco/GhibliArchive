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
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleJPLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.layer.opacity = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleENLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let seenLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = "Already seen"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "rt_score_icon"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let seenIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "eye"))
        imageView.layer.cornerRadius = 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .init(width: 0, height: 4)
        view.layer.masksToBounds = false
        view.backgroundColor = .white
        return view
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.cardView.layer.shadowPath = UIBezierPath(
                roundedRect: self.cardView.bounds,
                cornerRadius: self.cardView.layer.cornerRadius
            ).cgPath
        }
    }
    
    private func setupViews() {
        let textStack = UIStackView(arrangedSubviews: [titleJPLabel, titleENLabel, durationLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        let ratingStack = UIStackView(arrangedSubviews: [ratingIcon, ratingLabel])
        ratingStack.axis = .horizontal
        ratingStack.spacing = 4
        
        let seenStack = UIStackView(arrangedSubviews: [seenIcon, seenLabel])
        seenStack.axis = .horizontal
        seenStack.spacing = 4
        
        let infoStack = UIStackView(arrangedSubviews: [ratingStack, seenStack])
        infoStack.axis = .horizontal
        infoStack.spacing = 12
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStack = UIStackView(arrangedSubviews: [textStack, infoStack])
        mainStack.axis = .vertical
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(cardView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(mainStack)
        
        // Constraints
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.4),

            mainStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor),

            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            cardView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    // MARK: - Configure
    func configure(with viewModel: MostRatedFilmViewModel) {
        viewModel.poster
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in self?.posterImageView.image = image }
            .store(in: &cancellables)
        titleJPLabel.text = viewModel.originalTitle
        titleENLabel.text = viewModel.title
        durationLabel.text = viewModel.runningTime
        ratingLabel.text = "\(viewModel.rtScore)%"
        seenLabel.text = viewModel.wasWatched ? "Already seen" : "Not seen yet"
        seenIcon.isHidden = !viewModel.wasWatched
        seenLabel.isHidden = !viewModel.wasWatched
    }
}
