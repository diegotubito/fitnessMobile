//
//  String+Extension.swift
//  HayEquipo
//
//  Created by David Gomez on 23/04/2023.
//

import Foundation

extension String {
    func trimmedAndSingleSpaced() -> String {
        // Trim spaces from the beginning and end
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Replace double spaces (or more) with single space
        return trimmedString.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    }
}

extension String {
    
    func toDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateNSDate = dateFormatter.date(from: self)
        
        return dateNSDate
    }
}

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: self)
    }
}

extension String {
    func showDate(format: String) -> String {
        return self.toDate()?.toString(format: format) ?? "wrong date"
    }
    
    func showTimeFormat() -> String {
        var result = self.showDate(format: "HH:mm")
        result.append("hs.")
        return result
    }
}


extension String {
    func doubleValueFromCurrencyString() -> Double? {
        let formatter = NumberFormatter()
        
        let currentLocale = Locale.current
        let localeIdentifier = currentLocale.identifier
        formatter.locale = Locale(identifier: localeIdentifier)

        // If direct conversion fails, try custom formatting
        let cleanedString = self.replacingOccurrences(of: formatter.currencySymbol ?? "", with: "")
            .replacingOccurrences(of: formatter.groupingSeparator ?? "", with: "")
            .replacingOccurrences(of: formatter.decimalSeparator ?? "", with: ".")
        
        let cleanedStringWithNoSpaces = cleanedString.trimmingCharacters(in: .whitespaces)
        return Double(cleanedStringWithNoSpaces)
    }
}

extension String {
    static func generateMongoDBObjectId() -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        let machineId = Int.random(in: 0..<16777216) // 3 bytes in hexadecimal
        let processId = Int.random(in: 0..<65536) // 2 bytes in hexadecimal
        let counter = Int.random(in: 0..<16777216) // 3 bytes in hexadecimal
        
        let timestampHex = String(format: "%08x", timestamp)
        let machineIdHex = String(format: "%06x", machineId)
        let processIdHex = String(format: "%04x", processId)
        let counterHex = String(format: "%06x", counter)
        
        return timestampHex + machineIdHex + processIdHex + counterHex
    }
}
