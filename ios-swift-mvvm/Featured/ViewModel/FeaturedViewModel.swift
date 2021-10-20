//
//  FeaturedViewModel.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 20/10/21.
//

import Foundation

final class FeaturedViewModel {
    
    /// Model status
    enum Status {
        case initial
        case loading
        case didLoaded([FeaturedDisplayModel])
        case didFailed(Error)
    }
    
    /// View Model Configuration
    struct FeaturedDisplayModel {
        let name: String
        let image: String
        let price: Float
        let discount: Int
    }
    
    /// Properties
    private let featuredService: FeaturedService
    private var featuredItems: [FeaturedModel] = []
    var updateStatusHandler: ((Status) -> Void)?
    
    var currentState: Status = .initial {
        didSet {
            updateStatusHandler?(currentState)
        }
    }
    
    /// Initializer
    init(featuredService: FeaturedService = .init()) {
        self.featuredService = featuredService
    }
    
    /// Public methods
    func getFeaturedItems() {
        switch currentState {
        case .loading:
            return
        default:
            break
        }
        
        currentState = .loading
        
        featuredService.getFeatured(completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let featuredItems):
                self.featuredItems = featuredItems
                let models = featuredItems.map { FeaturedDisplayModel(name: $0.name, image: $0.image, price: $0.price, discount: $0.discount) }
                self.currentState = .didLoaded(models)
            case .failure(let error):
                self.currentState = .didFailed(error)
            }
        })
    }
    
}
