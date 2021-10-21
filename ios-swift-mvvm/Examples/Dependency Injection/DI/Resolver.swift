//
//  Resolver.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 21/10/21.
//

import Foundation

public protocol Resolver {
    func resolve<ServiceType>(_ type: ServiceType.Type) throws -> ServiceType
    
    func resolve<ServiceType>() throws -> ServiceType
}
