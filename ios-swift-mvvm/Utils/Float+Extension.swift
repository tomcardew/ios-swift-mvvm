//
//  Float+Extension.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 20/10/21.
//

import Foundation

extension Float {
    
    func asCurrency(locale: Locale = .current) -> String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = locale
        
        return currencyFormatter.string(from: NSNumber(value: self))
    }
    
}
