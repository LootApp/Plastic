//
//  Plastic.swift
//  Plastic
//
//  Created by Kyle McAlpine on 25/03/2016.
//  Copyright © 2016 Loot Financial Services Ltd. All rights reserved.
//

import Foundation

public protocol Luhnable {
    func plastic_luhnValidate() -> Bool
}

extension String: Luhnable {
    public func plastic_luhnValidate() -> Bool {
        let cleanString = self.removeNonDigits()
        guard cleanString.characters.count > 0 else { return false }

        var isOdd = true // Luhn number positions begin at 1, which is odd
        var oddSum = 0
        var evenSum = 0

        for i in stride(from: (cleanString.characters.count - 1), through: 0, by: -1) {
            guard let digit = Int(String(cleanString.characters[cleanString.characters.index(cleanString.characters.startIndex, offsetBy: i)])) else { continue }

            if isOdd {
                oddSum += digit
            } else {
                evenSum += digit / 5 + (2 * digit) % 10
            }

            isOdd = !isOdd
        }

        return (oddSum + evenSum) % 10 == 0
    }
}

public enum CardType: CustomStringConvertible {
    case amex
    case dinersClub
    case discover
    case jcb
    case masterCard
    case visa

    var regexString: String {
        switch self {
        case .amex:         return "^3[47][0-9]{5,}$"
        case .dinersClub:   return  "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .discover: 	return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .jcb:          return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .masterCard:   return "^5[1-5][0-9]{5,}$"
        case .visa:         return "^4[0-9]{6,}$"
        }
    }

    var regex: NSRegularExpression {
        return try! NSRegularExpression(pattern: self.regexString, options: [])
    }

    static var allCases: [CardType] {
        return [.amex, .dinersClub, .discover, .jcb, .masterCard, .visa]
    }

    public var description: String {
        switch self {
        case .amex:          return "Amex"
        case .dinersClub:    return "Diners Club"
        case .discover:      return "Discover"
        case .jcb:           return "JCB"
        case .masterCard:    return "MasterCard"
        case .visa:          return "Visa"
        }
    }
}

public enum PlasticError: Error {
    case invalidCardNumber
}

public protocol CardTypeConvertible: Luhnable {
    func plastic_cardType() throws -> CardType
}

extension String: CardTypeConvertible {
    public func plastic_cardType() throws -> CardType {
        guard self.plastic_luhnValidate() else { throw PlasticError.invalidCardNumber }

        let formatted = self.removeNonDigits()
        guard formatted.characters.count >= 9 else { throw PlasticError.invalidCardNumber }

        var type: CardType?
        for cardType in CardType.allCases {
            if cardType.regex.numberOfMatches(in: self, options: [], range: NSMakeRange(0, self.characters.count)) > 0 {
                type = cardType
                break
            }
        }
        if let type = type { return type }
        throw PlasticError.invalidCardNumber
    }
}

// Helper
extension String {
    fileprivate func removeNonDigits() -> String {
        let illegalCharacters = CharacterSet.decimalDigits.inverted
        let components = self.components(separatedBy: illegalCharacters)
        return components.joined(separator: "")
    }
}
