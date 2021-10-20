//
//  FeaturedModel.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 20/10/21.
//

import Foundation

struct FeaturedModel: Codable {
    let createdAt: String
    let name: String
    let slug: String
    let image: String
    let price: Float
    let discount: Int
    let description: String
    let storeName: String
    let id: String
}
