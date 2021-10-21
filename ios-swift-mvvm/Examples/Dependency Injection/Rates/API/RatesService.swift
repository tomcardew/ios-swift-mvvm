//
//  LoginService.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 21/10/21.
//

import Foundation

final class RatesService {
    private let networkRequester: NetworkRequester
    private let request: NetworkRequest
    
    init(networkRequester: NetworkRequester = .init(), request: NetworkRequest = NetworkRequest(apiRequest: RatesRequest())) {
        self.networkRequester = networkRequester
        self.request = request
    }
    
    func getRates(completionHandler: @escaping(Result<[RateModel], Error>)->Void) {
        networkRequester.requestService(request: request, completion: { (result: Result<[RateModel], Error>) in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        })
    }
}
