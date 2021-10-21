//
//  Injector.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 21/10/21.
//

import Foundation

public struct Injector {
    
    private static var container: Container?
    public static var solver: Resolver?
    
    static func registerAllServices() {
        if container == nil {
            self.container = Container().register(RatesService.self, instance: RatesService())
        }
        solver = self.container!.resolver
    }
    
}
