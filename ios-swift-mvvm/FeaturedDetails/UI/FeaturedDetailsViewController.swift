//
//  FeaturedDetailsViewController.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 20/10/21.
//

import UIKit

class FeaturedDetailsViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: FeaturedDetailsViewModel

    // MARK: - Initializer
    init(viewModel: FeaturedDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.getFeaturedItem()
    }
    
    private func bindViewModel() {
        viewModel.updateStatusHandler = self.updateState(_:)
    }
    
    // MARK: - Bindings
    private func updateState(_ state: FeaturedDetailsViewModel.Status) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch state {
            case .loaded(let model):
                self.title = model.name
            default:
                break
            }
        }
    }

}
