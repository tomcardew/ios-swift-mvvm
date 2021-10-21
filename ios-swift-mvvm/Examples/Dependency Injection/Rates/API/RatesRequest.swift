//
//  LoginRequest.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 21/10/21.
//

import Foundation

struct RatesRequest: APIRequest {
    var url: URL {
        ApiUrl.dev.convertedUrl
    }
    var method: HTTPMethod {
        .get
    }
    var path: ApiPath {
        .exchangeRates
    }
    var additionalPathParams: [String]? {
        nil
    }
    var queryTimes: [URLQueryItem]? {
        nil
    }
}
