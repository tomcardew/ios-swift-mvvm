//
//  ServiceFactory.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 21/10/21.
//

import Foundation

protocol ServiceFactory {
    
    associatedtype ServiceType
    
    func resolve(_ resolver: Resolver) throws -> ServiceType
}

extension ServiceFactory {
    
    /// Checks if the service factory supports creation of the specific `ServiceType`
    func supports<ServiceType>(_ type: ServiceType.Type) -> Bool {
        return type == ServiceType.self
    }
    
}
