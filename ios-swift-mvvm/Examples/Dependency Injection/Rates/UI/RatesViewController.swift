//
//  RatesViewController.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 21/10/21.
//

import UIKit

class RatesViewController: UIViewController {
    
    private let viewModel: RatesViewModel
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initializer
    init(viewModel: RatesViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addLayout()
        bindViewModel()
        viewModel.getRates()
    }
    
    private func configureView() {
        view.addSubview(label)
    }
    
    private func addLayout() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10)
        ])
    }
    
    private func bindViewModel() {
        viewModel.updateStatusHandler = self.updateState(_:)
    }
    
    // MARK: - Bindings
    private func updateState(_ state: RatesViewModel.Status) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch state {
            case .loaded:
                self.label.text = "\(self.viewModel.getAllRates())"
            default:
                break
            }
        }
    }
    
}
