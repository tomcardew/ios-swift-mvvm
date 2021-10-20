//
//  NetworkRequest.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 20/10/21.
//

import Foundation
import UIKit

struct NetworkRequest {
    var request: URLRequest
    
    init(apiRequest: APIRequest) {
        var urlComponents = URLComponents(string: apiRequest.url.description)
        urlComponents?.path = apiRequest.path.rawValue
        urlComponents?.queryItems = apiRequest.queryTimes
        
        guard let fullURL = urlComponents?.url else {
            assertionFailure("Couldn't build the URL")
            self.request = URLRequest(url: URL(string: "")!)
            return
        }
        
        self.request = URLRequest(url: fullURL)
        self.request.httpMethod = apiRequest.method.rawValue
    }
}
