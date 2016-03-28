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
        let formatted = self.stringForProcessing()
        guard formatted.characters.count >= 9 else { return false }
        
        var reversedString = ""
        
        formatted.enumerateSubstringsInRange(formatted.startIndex..<formatted.endIndex, options: [.Reverse, .ByComposedCharacterSequences]) { (substring, substringRange, enclosingRange, stop) in
            guard let substring = substring else { return }
            reversedString += substring
        }
        
        var oddSum = 0
        var evenSum = 0
        
        for i: Int in 0..<reversedString.characters.count {
            guard let digit = Int(String(reversedString.characters[reversedString.characters.startIndex.advancedBy(i)])) else { continue }
            
            if i % 2 == 0 {
                evenSum += digit
            } else {
                oddSum += digit / 5 + (2 * digit) % 10
            }
        }
        return (oddSum + evenSum) % 10 == 0
    }
}

public enum CardType: CustomStringConvertible {
    case Amex
    case DinersClub
    case Discover
    case JCB
    case Mastercard
    case Visa
    
    var regexString: String {
        switch self {
        case .Amex:         return "^3[47][0-9]{5,}$"
        case .DinersClub:   return  "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .Discover: 	return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .JCB:          return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case Mastercard:    return "^5[1-5][0-9]{5,}$"
        case .Visa:         return "^4[0-9]{6,}$"
        }
    }
    
    var regex: NSRegularExpression {
        return try! NSRegularExpression(pattern: self.regexString, options: [])
    }
    
    static var allCases: [CardType] {
        return [.Amex, .DinersClub, .Discover, .JCB, .Mastercard, .Visa]
    }
    
    public var description: String {
        switch self {
        case Amex:          return "Amex"
        case DinersClub:    return "Diners Club"
        case Discover:      return "Discover"
        case JCB:           return "JCB"
        case Mastercard:    return "Mastercard"
        case Visa:          return "Visa"
        }
    }
}

public enum LuhnError: ErrorType {
    case InvalidCardNumber
}

public protocol CardTypeConvertible: Luhnable {
    func plastic_cardType() throws -> CardType
}

extension String: CardTypeConvertible {
    public func plastic_cardType() throws -> CardType {
        guard self.plastic_luhnValidate() else { throw LuhnError.InvalidCardNumber }
        
        let formatted = self.stringForProcessing()
        guard formatted.characters.count >= 9 else { throw LuhnError.InvalidCardNumber }
        
        var type: CardType?
        for cardType in CardType.allCases {
            if cardType.regex.numberOfMatchesInString(self, options: [], range: NSMakeRange(0, self.characters.count)) > 0 {
                type = cardType
                break
            }
        }
        if let type = type { return type }
        throw LuhnError.InvalidCardNumber
    }
    
    private func stringForProcessing() -> String {
        let illegalCharacters = NSCharacterSet.decimalDigitCharacterSet().invertedSet
        let components = self.componentsSeparatedByCharactersInSet(illegalCharacters)
        return components.joinWithSeparator("")
    }
}
