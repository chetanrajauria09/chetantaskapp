//
//  PortfolioViewModel.swift
//  ChetanTaskApp
//
//  Created by Chetan Rajauria on 08/07/25.
//

import Foundation

@MainActor
final class PortfolioViewModel {
    private let repository: PortfolioRepository
    private(set) var holdings: [Holding] = []
    private(set) var currentValue: Double = 0
    private(set) var totalInvestment: Double = 0
    private(set) var totalPNL: Double = 0
    private(set) var todaysPNL: Double = 0
    var onUpdate: (() -> Void)?
    var onLoadingChange: ((Bool) -> Void)?

    init(repository: PortfolioRepository = DefaultPortfolioRepository()) {
        self.repository = repository
    }

    func loadHoldings() {
        Task {
            onLoadingChange?(true)
            defer { onLoadingChange?(false) }

            do {
                self.holdings = try await repository.fetchHoldings()
                self.calculateSummary()
                self.onUpdate?()
            } catch {
                print("Fetch failed:", error)
            }
        }
    }

    func setHoldings(_ holdings: [Holding]) {
        self.holdings = holdings
        calculateSummary()
        onUpdate?()
    }

    func calculateSummary() {
        currentValue = holdings.reduce(0) { $0 + $1.ltp * Double($1.quantity) }
        totalInvestment = holdings.reduce(0) { $0 + $1.avgPrice * Double($1.quantity) }
        totalPNL = currentValue - totalInvestment
        todaysPNL = holdings.reduce(0) { $0 + ($1.close - $1.ltp) * Double($1.quantity) }
    }
}
