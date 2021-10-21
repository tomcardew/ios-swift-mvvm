//
//  FeaturedDetailsService.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 20/10/21.
//

import Foundation

final class FeaturedDetailsService {
    private let networkRequester: NetworkRequester
    private let request: NetworkRequest
    
    init(networkRequester: NetworkRequester = .init(), itemSelected: String) {
        self.networkRequester = networkRequester
        self.request = NetworkRequest(apiRequest: FeaturedDetailsRequest(additionalPathParams: [itemSelected]))
    }
    
    func getFeatureDetails(completionHandler: @escaping (Result<FeaturedModel, Error>) -> Void) {
        networkRequester.requestService(request: request, completion: { (result: Result<FeaturedModel, Error>) in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        })
    }
}
