//
//  PortfolioRepository.swift
//  ChetanTaskApp
//
//  Created by Chetan Rajauria on 08/07/25.
//

import Foundation

protocol PortfolioRepository {
    func fetchHoldings() async throws -> [Holding]
}

final class DefaultPortfolioRepository: PortfolioRepository {
    func fetchHoldings() async throws -> [Holding] {
        return try await APIClient.shared.fetchHoldings()
    }
}
