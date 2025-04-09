//
//  StatefulViewController.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Combine
import UIKit

class StatefulViewController: UIViewController {
    
    // MARK: - UI Components
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.color = .gray
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    lazy var warningView: WarningView = .init()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI Logics
    
    func startLoading() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fulfillSuperview()
        activityIndicatorView.startAnimating()
    }
    
    func stopLoading() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
    
    func showWarningView(with viewModel: WarningViewModel) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(warningView)
        warningView.configure(viewModel: viewModel)
        warningView.fulfillSuperview()
    }
    
    func removeWarningView() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        warningView.removeFromSuperview()
    }
}
