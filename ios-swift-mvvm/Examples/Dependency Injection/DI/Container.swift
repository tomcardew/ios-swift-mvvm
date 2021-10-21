//
//  Container.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 21/10/21.
//

import Foundation

public class Container {
    let dependency: Resolver?
    let factories: [AnyServiceFactory]
    
    public init(dependency: Resolver? = nil) {
        self.dependency = dependency
        self.factories = []
    }
    
    init(dependency: Resolver? = nil, factories: [AnyServiceFactory]) {
        self.dependency = dependency
        self.factories = factories
    }
    
    public func register<ServiceType>(_ interface: ServiceType.Type, instance: ServiceType) -> Container {
        return register(interface) { _ in instance }
    }
    
    public func register<ServiceType>(_ interface: ServiceType.Type, _ factory: @escaping (Resolver) -> ServiceType) -> Container {
        let newFactory = BasicServiceFactory<ServiceType>(interface, factory: { resolver in
            factory(resolver)
        })
        return .init(dependency: dependency, factories: factories + [AnyServiceFactory(newFactory)])
    }
    
}

extension Container: Resolver {

    public var resolver: Resolver { return self as Resolver }
    
    public func resolve<ServiceType>(_ type: ServiceType.Type) throws -> ServiceType {
        guard let factory = factories.first(where: { $0.supports(type) }) else {
            guard let resolvedByDependency = try dependency?.resolve(type) else {
                throw Container.unableToResolve(type)
            }
            return resolvedByDependency
        }
        
        return try factory.resolve(self)
    }
    
    public func resolve<ServiceType>() throws -> ServiceType {
        return try resolve(ServiceType.self)
    }
    
}

extension Container {
    public static func unableToResolve<ServiceType>(_ type: ServiceType.Type) -> Error {
        return .factoryNotFound(service: type)
    }
    
    public enum Error: Swift.Error, Equatable {
        public static func == (lhs: Container.Error, rhs: Container.Error) -> Bool {
            switch (lhs, rhs) {
            case let (.factoryNotFound(lhsType), .factoryNotFound(rhsType)):
                return rhsType == lhsType
            }
        }
        
        case factoryNotFound(service: Any.Type)
    }
}
