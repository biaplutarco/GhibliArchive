//
//  ErrorView.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 07/04/25.
//

import UIKit

protocol ErrorViewDelegate: AnyObject {
    func didTapRetryButton()
}

final class ErrorView: UIView {
    weak var delegate: ErrorViewDelegate?

    // MARK: - Subviews

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "error_image")
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ghibli_blue")
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Try again", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "ghibli_blue")
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    func configure(with message: String, andTitle title: String) {
        messageLabel.text = message
        titleLabel.text = title
        
        setup(with: [
            imageView,
            titleLabel,
            messageLabel,
            retryButton
        ])
        
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
    }
    
    @objc private func didTapRetry() {
        delegate?.didTapRetryButton()
    }
}

extension ErrorView: ViewCodable {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            messageLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 56),
            retryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            retryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            retryButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
}
