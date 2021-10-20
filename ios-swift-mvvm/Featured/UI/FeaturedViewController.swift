//
//  FeaturedViewController.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 20/10/21.
//

import UIKit

class FeaturedViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: FeaturedViewModel
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.color = .darkGray
        loadingView.startAnimating()
        return loadingView
    }()
    
    // MARK: - Initializer
    init(viewModel: FeaturedViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Life Cycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addLayout()
        bindViewModel()
        viewModel.getFeaturedItems()
    }
    
    // MARK: - Configurations
    private func configureView() {
        view.addSubview(loadingIndicator)
    }
    
    private func addLayout() {
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 1),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 1),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func bindViewModel() {
        viewModel.updateStatusHandler = self.updateState(_:)
    }
    
    // MARK: - Bindings
    private func updateState(_ state: FeaturedViewModel.Status) {
        DispatchQueue.main.async { [weak self] in
            switch state {
            case .didLoaded(let items):
                self!.loadingIndicator.stopAnimating()
                print(items)
            default:
                break
            }
        }
    }
    
}
