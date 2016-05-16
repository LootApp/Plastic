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

        for i in (cleanString.characters.count - 1).stride(through: 0, by: -1) {
            guard let digit = Int(String(cleanString.characters[cleanString.characters.startIndex.advancedBy(i)])) else { continue }

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
    case Amex
    case DinersClub
    case Discover
    case JCB
    case MasterCard
    case Visa

    var regexString: String {
        switch self {
        case .Amex:         return "^3[47][0-9]{5,}$"
        case .DinersClub:   return  "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .Discover: 	return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .JCB:          return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .MasterCard:   return "^5[1-5][0-9]{5,}$"
        case .Visa:         return "^4[0-9]{6,}$"
        }
    }

    var regex: NSRegularExpression {
        return try! NSRegularExpression(pattern: self.regexString, options: [])
    }

    static var allCases: [CardType] {
        return [.Amex, .DinersClub, .Discover, .JCB, .MasterCard, .Visa]
    }

    public var description: String {
        switch self {
        case Amex:          return "Amex"
        case DinersClub:    return "Diners Club"
        case Discover:      return "Discover"
        case JCB:           return "JCB"
        case MasterCard:    return "MasterCard"
        case Visa:          return "Visa"
        }
    }
}

public enum PlasticError: ErrorType {
    case InvalidCardNumber
}

public protocol CardTypeConvertible: Luhnable {
    func plastic_cardType() throws -> CardType
}

extension String: CardTypeConvertible {
    public func plastic_cardType() throws -> CardType {
        guard self.plastic_luhnValidate() else { throw PlasticError.InvalidCardNumber }

        let formatted = self.removeNonDigits()
        guard formatted.characters.count >= 9 else { throw PlasticError.InvalidCardNumber }

        var type: CardType?
        for cardType in CardType.allCases {
            if cardType.regex.numberOfMatchesInString(self, options: [], range: NSMakeRange(0, self.characters.count)) > 0 {
                type = cardType
                break
            }
        }
        if let type = type { return type }
        throw PlasticError.InvalidCardNumber
    }
}

// Helper
extension String {
    private func removeNonDigits() -> String {
        let illegalCharacters = NSCharacterSet.decimalDigitCharacterSet().invertedSet
        let components = self.componentsSeparatedByCharactersInSet(illegalCharacters)
        return components.joinWithSeparator("")
    }
}
