//
//  FeaturedDetailsViewModel.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 20/10/21.
//

import Foundation

final class FeaturedDetailsViewModel {
    
    /// Model status
    enum Status {
        case initial
        case loading
        case loaded(model: FeaturedDetailsDisplayModel)
        case failed(Error)
    }
    
    /// View Model Configuration
    struct FeaturedDetailsDisplayModel {
        let name: String
        let image: String
        let price: Float
        let description: String
        let storeName: String
    }
    
    /// Properties
    private let featuredDetailsService: FeaturedDetailsService
    private var featuredItem: FeaturedModel? = nil
    var updateStatusHandler: ((Status) -> Void)?
    
    var currentState: Status = .initial {
        didSet {
            updateStatusHandler?(currentState)
        }
    }
    
    /// Initializer
    init(featuredDetailsService: FeaturedDetailsService) {
        self.featuredDetailsService = featuredDetailsService
    }
    
    /// Public methods
    func getFeaturedItem() {
        switch currentState {
        case .loading:
            return
        default:
            break
        }
        
        currentState = .loading
        
        featuredDetailsService.getFeatureDetails(completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let featuredItem):
                self.featuredItem = featuredItem
                self.currentState = .loaded(model: FeaturedDetailsDisplayModel(name: featuredItem.name, image: featuredItem.image, price: featuredItem.price, description: featuredItem.description, storeName: featuredItem.storeName))
            case .failure(let error):
                self.currentState = .failed(error)
            }
        })
    }
    
}
