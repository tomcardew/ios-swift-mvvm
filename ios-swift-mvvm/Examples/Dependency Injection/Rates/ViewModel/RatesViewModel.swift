//
//  RatesViewModel.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 21/10/21.
//

import Foundation

final class RatesViewModel {
    
    enum Status {
        case initial
        case loading
        case loaded
        case failed(Error)
    }
    
    private let service: RatesService
    private var rates: [RateModel] = []
    var updateStatusHandler: ((Status) -> Void)?
    
    var currentState: Status = .initial {
        didSet {
            updateStatusHandler?(currentState)
        }
    }
    
    init(service: RatesService = try! Injector.solver!.resolve()) {
        self.service = service
    }
    
    func getRates() {
        switch currentState {
        case .loading:
            return
        default:
            break
        }
        
        currentState = .loading
        
        service.getRates(completionHandler:  { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let rates):
                print("Aaaaaaaa")
                self.rates = rates
                self.currentState = .loaded
            case .failure(let error):
                self.currentState = .failed(error)
            }
        })
    }
    
    func getAllRates() ->  [RateModel] {
        return self.rates
    }
    
}
