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
        let loadingView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.color = .darkGray
        loadingView.startAnimating()
        return loadingView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        return collectionView
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
        self.title = "Featured"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
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
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
    }
    
    private func addLayout() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 1),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 1),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 1)
        ])
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
            guard let self = self else { return }
            switch state {
            case .loaded:
                self.collectionView.reloadData()
                self.loadingIndicator.stopAnimating()
            default:
                break
            }
        }
    }
    
}

extension FeaturedViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getFeaturedItemsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifier, for: indexPath) as? ItemCell else {
            assertionFailure("Could not dequeue cell")
            return UICollectionViewCell()
        }
        cell.configureWith(viewModel.cellModelAt(indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return DesignConstants.cellItemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: DesignConstants.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let nViewModel = viewModel.getViewModelAt(indexPath.row)
//        let view = FeaturedDetailsViewController(viewModel: nViewModel)
        let view = RatesViewController()
        self.navigationController?.pushViewController(view, animated: true)
    }
    
}

// MARK: - View Constants
private extension FeaturedViewController {
    private enum DesignConstants {
        static let cellSize: CGFloat = 100.0
        static let cellItemSpace: CGFloat = 8.0
        static let collectionViewHeight: CGFloat = 180.0
    }
}
