//
//  APIRequest.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 20/10/21.
//

import Foundation

protocol APIRequest {
    var url: URL { get }
    var path: ApiPath { get }
    var additionalPathParams: [String]? { get }
    var method: HTTPMethod { get }
    var queryTimes: [URLQueryItem]? { get }
}
