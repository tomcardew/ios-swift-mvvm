//
//  BasicServiceFactory.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 21/10/21.
//

import Foundation

struct BasicServiceFactory<ServiceType>: ServiceFactory {
    private let factory: (Resolver) throws -> ServiceType
    
    init(_ type: ServiceType.Type, factory: @escaping (Resolver) throws -> ServiceType ) {
        self.factory = factory
    }
    
    func resolve(_ resolver: Resolver) throws -> ServiceType {
        return try factory(resolver)
    }
}
