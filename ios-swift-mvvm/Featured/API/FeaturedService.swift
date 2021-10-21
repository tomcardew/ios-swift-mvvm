//
//  FeaturedService.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 20/10/21.
//

import Foundation

final class FeaturedService {
    private let networkRequester: NetworkRequester
    private let request: NetworkRequest
    
    init(networkRequester: NetworkRequester = .init(), request: NetworkRequest = NetworkRequest(apiRequest: FeaturedRequest())) {
        self.networkRequester = networkRequester
        self.request = request
    }
    
    func getFeatured(completionHandler: @escaping(Result<[FeaturedModel], Error>)->Void) {
        networkRequester.requestService(request: request, completion: { (result: Result<[FeaturedModel], Error>) in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        })
    }
}
