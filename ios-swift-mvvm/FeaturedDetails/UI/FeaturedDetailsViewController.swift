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
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.borderWidth = 2.0
        contentView.layer.borderColor = UIColor.red.cgColor
        contentView.layer.masksToBounds = false
        return contentView
    }()
    
    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private var destroyImageTask: () -> Void = {}

    // MARK: - Initializer
    init(viewModel: FeaturedDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Life Cycle
    override func loadView() {
        super.loadView()
        navigationController?.navigationBar.isTranslucent = true
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        addLayout()
        bindViewModel()
        viewModel.getFeaturedItem()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print(contentView.bounds.size)
//        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 2)
    }
    
    // MARK: - Configurations
    private func configureViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(itemImageView)
    }
    
    private func addLayout() {
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemImageView.heightAnchor.constraint(equalTo: itemImageView.widthAnchor)
        ])
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
                let token = ImageLoader.shared.loadImage(model.url!) { [weak self] result in
                    guard let self = self else { return }
                    do {
                        let image = try result.get()
                        DispatchQueue.main.async {
                            self.itemImageView.image = image
                        }
                    } catch {
                        print(error)
                    }
                }
                self.destroyImageTask = {
                    if let token = token {
                        ImageLoader.shared.cancelLoad(token)
                    }
                }
            default:
                break
            }
        }
    }

}
