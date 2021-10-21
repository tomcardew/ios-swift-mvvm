//
//  RateModel.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 21/10/21.
//

import Foundation

struct RateModel: Codable {
    let id: String
    let timestamp: Double
    let base: String
    let mxn: String
    let aed: String
    let ang: String
}
