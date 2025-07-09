//
//  HoldingTableViewCellTests.swift
//  ChetanTaskAppTests
//
//  Created by Chetan Rajauria on 09/07/25.
//

import XCTest
@testable import ChetanTaskApp

final class HoldingTableViewCellTests: XCTestCase {

    func testConfigure_positivePNL_shouldDisplayGreenColorAndCorrectValues() {
        let cell = HoldingTableViewCell(style: .default, reuseIdentifier: HoldingTableViewCell.identifier)
        let holding = Holding(symbol: "ICICI", quantity: 10, ltp: 150.0, avgPrice: 100.0, close: 140.0)

        cell.configure(with: holding)

        let labels = getAllLabels(from: cell)
        XCTAssertTrue(labels.contains(where: { $0.text == "ICICI" }))
        XCTAssertTrue(labels.contains(where: { $0.text?.contains("₹150.00") == true }))
        XCTAssertTrue(labels.contains(where: { $0.text?.contains("₹500.00") == true }))

        let pnlLabel = labels.first(where: { $0.text?.contains("₹500.00") == true })
        XCTAssertEqual(pnlLabel?.textColor, .systemGreen)
    }

    func testConfigure_negativePNL_shouldDisplayRedColorAndCorrectValues() {
        let cell = HoldingTableViewCell(style: .default, reuseIdentifier: HoldingTableViewCell.identifier)
        let holding = Holding(symbol: "SBI", quantity: 5, ltp: 80.0, avgPrice: 100.0, close: 90.0)

        cell.configure(with: holding)

        let labels = getAllLabels(from: cell)
        XCTAssertTrue(labels.contains(where: { $0.text == "SBI" }))
        XCTAssertTrue(labels.contains(where: { $0.text?.contains("₹80.00") == true }))
        XCTAssertTrue(labels.contains(where: { $0.text?.contains("₹-100.00") == true }))

        let pnlLabel = labels.first(where: { $0.text?.contains("₹-100.00") == true })
        XCTAssertEqual(pnlLabel?.textColor, .systemRed)
    }

    func testConfigure_quantityLabel_shouldContainAttributedText() {
        let cell = HoldingTableViewCell(style: .default, reuseIdentifier: HoldingTableViewCell.identifier)
        let holding = Holding(symbol: "TCS", quantity: 42, ltp: 3200.0, avgPrice: 3000.0, close: 3100.0)

        cell.configure(with: holding)

        let labels = getAllLabels(from: cell)
        let quantityLabel = labels.first(where: { $0.attributedText?.string.contains("Net QTY") == true })

        XCTAssertNotNil(quantityLabel?.attributedText)
        XCTAssertTrue(quantityLabel!.attributedText!.string.contains("42"))
    }

    private func getAllLabels(from view: UIView) -> [UILabel] {
        var result = [UILabel]()
        for subview in view.subviews {
            if let label = subview as? UILabel {
                result.append(label)
            } else {
                result.append(contentsOf: getAllLabels(from: subview))
            }
        }
        return result
    }
}
