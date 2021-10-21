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
        case loaded
        case failed(Error)
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
                self.currentState = .loaded
            case .failure(let error):
                self.currentState = .failed(error)
            }
        })
    }
    
    func getFeaturedItemsCount() -> Int {
        return self.featuredItems.count
    }
    
    func getViewModelAt(_ index: Int) -> FeaturedDetailsViewModel {
        let model = featuredItems[index]
        return FeaturedDetailsViewModel(featuredDetailsService: .init(itemSelected: model.id))
    }
    
    func cellModelAt(_ index: Int) -> ItemCell.Model {
        let item = featuredItems[index]
        return ItemCell.Model(name: item.name, price: item.price, discount: item.discount, image: item.image)
    }
    
}
