//
//  FeaturedRequest.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 20/10/21.
//

import Foundation

struct FeaturedRequest: APIRequest {
    var url: URL {
        ApiUrl.dev.convertedUrl
    }
    var path: ApiPath {
        .featured
    }
    var queryTimes: [URLQueryItem]? {
        nil
    }
    var method: HTTPMethod {
        .get
    }
    var additionalPathParams: [String]? {
        []
    }
}
