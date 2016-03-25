//
//  PlasticTests.swift
//  PlasticTests
//
//  Created by Kyle McAlpine on 25/03/2016.
//  Copyright © 2016 Loot Financial Services Ltd. All rights reserved.
//

import XCTest
@testable import Plastic

class PlasticTests: XCTestCase {
    var validNumbers: [[String : String]]!
    var invalidNumbers: [String]!
    
    override func setUp() {
        super.setUp()
        let path = NSBundle(forClass: self.dynamicType).pathForResource("TestCardNumbers", ofType: "plist")!
        let testNumbers = NSDictionary(contentsOfFile: path)!
        self.validNumbers = testNumbers["valid"] as! [[String : String]]
        self.invalidNumbers = testNumbers["invalid"] as! [String]
    }
    
    func testValidNumbers() {
        for numberData in self.validNumbers {
            let number = numberData["number"]!
            let type = numberData["type"]!
            XCTAssertTrue(number.plastic_luhnValidate())
            XCTAssertTrue(try! number.plastic_cardType().description.lowercaseString == type)
        }
    }
    
    func testInvalidNumbers() {
        for number in self.invalidNumbers {
            XCTAssertFalse(number.plastic_luhnValidate())
        }
    }
}
