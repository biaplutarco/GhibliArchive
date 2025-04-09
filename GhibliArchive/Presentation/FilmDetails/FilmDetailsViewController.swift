//
//  FilmDetailsViewController.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Combine
import UIKit

final class FilmDetailsViewController: StatefulViewController {
    
    // MARK: - Properties
    private let viewModel: FilmDetailsViewModelProtocol
    private lazy var filmDetailsContentView: FilmDetailsContentView = {
        let contentView = FilmDetailsContentView()
        contentView.delegate = self
        return contentView
    }()
    
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Initialization
    init(viewModel: FilmDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(with: [filmDetailsContentView])
        bindViewModel()
        
        viewModel.start()
    }
    
    // MARK: - Setup Bindings

    private func bindViewModel() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { state in
                self.render(state)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Logic
    
    private func render(_ state: FilmDetailsViewControllerState) {
        switch state {
        case .error(let viewModel):
            stopLoading()
            showWarningView(with: viewModel)
        case .loading:
            startLoading()
        case .success(let viewModel):
            stopLoading()
            removeWarningView()
            filmDetailsContentView.configure(with: viewModel)
        case .alert(let message):
            present(createAlert(message: message), animated: true)
        }
    }
}

// MARK: - ViewCodable

extension FilmDetailsViewController: ViewCodable {
    func setupConstraints() {
        filmDetailsContentView.fulfillSuperview()
    }
    
    func additionalSetup() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        
        warningView.delegate = self
    }
}

// MARK: - FilmDetailsContentViewDelegate

extension FilmDetailsViewController: FilmDetailsContentViewDelegate {
    func didTapFavorite() {
        viewModel.didTapFavorite()
    }
}

// MARK: - WarningViewDelegate

extension FilmDetailsViewController: WarningViewDelegate {
    func didTapButton() {
        removeWarningView()
        startLoading()
        viewModel.tryAgain()
    }
}
