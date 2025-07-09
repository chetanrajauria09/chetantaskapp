//
//  HoldingTableViewCellTests.swift
//  ChetanTaskAppTests
//
//  Created by Chetan Rajauria on 09/07/25.
//

import XCTest
@testable import ChetanTaskApp

final class HoldingTableViewCellTests: XCTestCase {
    
    func testConfigure_setsCorrectValuesForPositivePNL() {
        let cell = HoldingTableViewCell(style: .default, reuseIdentifier: HoldingTableViewCell.identifier)
        let holding = Holding(symbol: "ICICI", quantity: 10, ltp: 120.0, avgPrice: 100.0, close: 115.0)

        cell.configure(with: holding)

        let symbolLabel = getLabel(from: cell, containing: "ICICI")
        let quantityLabel = getLabel(from: cell, containing: "\(PortfolioStrings.netQuantity) 10")
        let ltpLabel = getLabel(from: cell, containing: String(format: "\(PortfolioStrings.ltp) ₹%.2f", 120.0))
        let pnlLabel = getLabel(from: cell, containing: "\(PortfolioStrings.pnl) ₹200.00")

        XCTAssertNotNil(symbolLabel)
        XCTAssertNotNil(quantityLabel)
        XCTAssertNotNil(ltpLabel)
        XCTAssertNotNil(pnlLabel)
    }

    func testConfigure_setsCorrectValuesForNegativePNL() {
        let cell = HoldingTableViewCell(style: .default, reuseIdentifier: HoldingTableViewCell.identifier)
        let holding = Holding(symbol: "SBI", quantity: 5, ltp: 90.0, avgPrice: 100.0, close: 98.0)

        cell.configure(with: holding)

        let pnlText = "\(PortfolioStrings.pnl) ₹-50.00"
        let pnlLabel = getLabel(from: cell, containing: pnlText)

        XCTAssertNotNil(pnlLabel)
        XCTAssertEqual(pnlLabel?.textColor, .systemRed)
    }

    private func getLabel(from view: UIView, containing text: String) -> UILabel? {
        for subview in view.subviews {
            if let label = subview as? UILabel, label.text == text {
                return label
            }
            if let found = getLabel(from: subview, containing: text) {
                return found
            }
        }
        return nil
    }
}
