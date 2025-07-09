//
//  PortfolioViewModelTests.swift
//  ChetanTaskAppTests
//
//  Created by Chetan Rajauria on 08/07/25.
//

import XCTest

@testable import ChetanTaskApp

@MainActor
final class PortfolioViewModelTests: XCTestCase {
    
    var viewModel: PortfolioViewModel!

    override func setUp() {
        super.setUp()
        viewModel = PortfolioViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testSummaryCalculation_withValidHoldings() {
        let holdings = [
            Holding(symbol: "ICICI", quantity: 10, ltp: 150, avgPrice: 100, close: 148),
            Holding(symbol: "SBI", quantity: 5, ltp: 800, avgPrice: 600, close: 790)
        ]
        viewModel.setHoldings(holdings)

        let expectedCurrentValue = holdings.reduce(0) { $0 + $1.ltp * Double($1.quantity) }
        let expectedInvestment = holdings.reduce(0) { $0 + $1.avgPrice * Double($1.quantity) }
        let expectedPNL = expectedCurrentValue - expectedInvestment
        let expectedTodaysPNL = holdings.reduce(0) { $0 + ($1.close - $1.ltp) * Double($1.quantity) }

        XCTAssertEqual(viewModel.currentValue, expectedCurrentValue, accuracy: 0.001)
        XCTAssertEqual(viewModel.totalInvestment, expectedInvestment, accuracy: 0.001)
        XCTAssertEqual(viewModel.totalPNL, expectedPNL, accuracy: 0.001)
        XCTAssertEqual(viewModel.todaysPNL, expectedTodaysPNL, accuracy: 0.001)
    }

    func testSummaryCalculation_withZeroQuantity() {
        let holdings = [
            Holding(symbol: "MAHABANK", quantity: 0, ltp: 100, avgPrice: 90, close: 98)
        ]
        viewModel.setHoldings(holdings)

        XCTAssertEqual(viewModel.currentValue, 0, accuracy: 0.001)
        XCTAssertEqual(viewModel.totalInvestment, 0, accuracy: 0.001)
        XCTAssertEqual(viewModel.totalPNL, 0, accuracy: 0.001)
        XCTAssertEqual(viewModel.todaysPNL, 0, accuracy: 0.001)
    }

    func testSummaryCalculation_withNegativePNL() {
        let holdings = [
            Holding(symbol: "INFOSYS", quantity: 10, ltp: 80, avgPrice: 100, close: 85)
        ]
        viewModel.setHoldings(holdings)

        let expectedCurrentValue = holdings.reduce(0) { $0 + $1.ltp * Double($1.quantity) }
        let expectedInvestment = holdings.reduce(0) { $0 + $1.avgPrice * Double($1.quantity) }
        let expectedPNL = expectedCurrentValue - expectedInvestment
        let expectedTodaysPNL = holdings.reduce(0) { $0 + ($1.close - $1.ltp) * Double($1.quantity) }

        XCTAssertEqual(viewModel.currentValue, expectedCurrentValue, accuracy: 0.001)
        XCTAssertEqual(viewModel.totalInvestment, expectedInvestment, accuracy: 0.001)
        XCTAssertEqual(viewModel.totalPNL, expectedPNL, accuracy: 0.001)
        XCTAssertEqual(viewModel.todaysPNL, expectedTodaysPNL, accuracy: 0.001)
    }

    func testSummaryCalculation_withHighPNL() {
        let holdings = [
            Holding(symbol: "AIRTEL", quantity: 1, ltp: 3000, avgPrice: 2000, close: 2900)
        ]
        viewModel.setHoldings(holdings)

        let expectedCurrentValue = holdings.reduce(0) { $0 + $1.ltp * Double($1.quantity) }
        let expectedInvestment = holdings.reduce(0) { $0 + $1.avgPrice * Double($1.quantity) }
        let expectedPNL = expectedCurrentValue - expectedInvestment
        let expectedTodaysPNL = holdings.reduce(0) { $0 + ($1.close - $1.ltp) * Double($1.quantity) }

        XCTAssertEqual(viewModel.currentValue, expectedCurrentValue, accuracy: 0.001)
        XCTAssertEqual(viewModel.totalInvestment, expectedInvestment, accuracy: 0.001)
        XCTAssertEqual(viewModel.totalPNL, expectedPNL, accuracy: 0.001)
        XCTAssertEqual(viewModel.todaysPNL, expectedTodaysPNL, accuracy: 0.001)
    }

    func testCallbackExecution_onUpdateCalled() {
        let expectation = self.expectation(description: "onUpdate called")
        viewModel.onUpdate = {
            expectation.fulfill()
        }
        viewModel.setHoldings([
            Holding(symbol: "NFLX", quantity: 1, ltp: 400, avgPrice: 350, close: 390)
        ])
        waitForExpectations(timeout: 1.0)
    }

    func testSummaryCalculation_withNoHoldings() {
        viewModel.setHoldings([])

        XCTAssertEqual(viewModel.currentValue, 0, accuracy: 0.001)
        XCTAssertEqual(viewModel.totalInvestment, 0, accuracy: 0.001)
        XCTAssertEqual(viewModel.totalPNL, 0, accuracy: 0.001)
        XCTAssertEqual(viewModel.todaysPNL, 0, accuracy: 0.001)
    }
}

