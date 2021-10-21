//
//  Collection+FirstToResolve.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 21/10/21.
//

import Foundation

// MARK: Internal API
extension Collection where Index == Int {

    /// tries to resolve the `ServiceType` and returns the instance as soon as the first element resolves it successfully.
    func firstToResolve<ServiceType>(_ factory: (Element) throws -> ServiceType) throws -> ServiceType {
        for element in self {
            if let resolved = try? factory(element) { return resolved }
        }

        throw Container.unableToResolve(ServiceType.self)
    }
}
