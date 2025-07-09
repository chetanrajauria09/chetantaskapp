//
//  PortfolioResponse.swift
//  ChetanTaskApp
//
//  Created by Chetan Rajauria on 08/07/25.
//

import Foundation

struct PortfolioResponse: Decodable {
    let data: HoldingData
}

struct HoldingData: Decodable {
    let userHolding: [Holding]
}

struct Holding: Decodable {
    let symbol: String
    let quantity: Int
    let ltp: Double
    let avgPrice: Double
    let close: Double
}
