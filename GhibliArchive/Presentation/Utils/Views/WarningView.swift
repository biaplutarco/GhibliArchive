//
//  ErrorView.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 07/04/25.
//

import UIKit

// MARK: - ViewModel

struct WarningViewModel {
    let title: String
    let message: String
    let buttonTitle: String
}

// MARK: - Protocol

protocol WarningViewDelegate: AnyObject {
    func didTapButton()
}

// MARK: - Class

final class WarningView: UIView {
    weak var delegate: WarningViewDelegate?

    // MARK: - UI Components

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .error
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ghibliBlue
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

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ghibliBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)

        return button
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            messageLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            textStackView,
            button
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 56
        return stackView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    func configure(viewModel: WarningViewModel) {
        messageLabel.text = viewModel.message
        titleLabel.text = viewModel.title
        button.setTitle(viewModel.buttonTitle, for: .normal)

        setup(with: [stackView])
    }
    
    // MARK: - Actions
    
    @objc private func didTapRetry() {
        delegate?.didTapButton()
    }
}

extension WarningView: ViewCodable {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
        ])
    }
    
    func additionalSetup() {
        backgroundColor = .white
    }
}
