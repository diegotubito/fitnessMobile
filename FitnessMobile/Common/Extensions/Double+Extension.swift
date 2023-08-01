//
//  Double+Extension.swift
//  HayEquipo
//
//  Created by David Gomez on 22/04/2023.
//

import Foundation

extension Double {
    var asCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current // Set the locale to the current user's locale, or use a specific one if needed
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension Double {
    func asCurrencyFormat(withDecimals: Bool) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        formatter.maximumFractionDigits = withDecimals ? 2 : 0
        formatter.minimumFractionDigits = withDecimals ? 2 : 0
        
        // Get local currency symbol
        let locale = Locale.current
        formatter.locale = locale
        let currencySymbol = locale.currencySymbol ?? ""
        formatter.currencySymbol = currencySymbol
        
        let value = NSNumber(value: self / (withDecimals ? 100 : 1) )
        return formatter.string(from: value) ?? "0"
    }
}
