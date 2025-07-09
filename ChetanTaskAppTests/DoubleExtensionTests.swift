//
//  DoubleExtensionTests.swift
//  ChetanTaskAppTests
//
//  Created by Chetan Rajauria on 09/07/25.
//

import XCTest
@testable import ChetanTaskApp

final class DoubleExtensionTests: XCTestCase {
    
    func testFormatted_returnsTwoDecimalPlaces() {
        XCTAssertEqual(123.456.formatted, "123.46")
        XCTAssertEqual(100.0.formatted, "100.00")
        XCTAssertEqual(0.1.formatted, "0.10")
    }
    
    func testFormatted_handlesNegativeNumbers() {
        XCTAssertEqual((-45.6789).formatted, "-45.68")
    }
}
