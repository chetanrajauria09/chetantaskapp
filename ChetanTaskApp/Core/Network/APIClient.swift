//
//  APIClient.swift
//  ChetanTaskApp
//
//  Created by Chetan Rajauria on 08/07/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingError
    case serverError(String)
}

final class APIClient {
    static let shared = APIClient()
    private init() {}

    func fetchHoldings() async throws -> [Holding] {
        let url = APIEndpoint.fetchHoldings.url
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(PortfolioResponse.self, from: data)
            return decoded.data.userHolding
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.serverError(error.localizedDescription)
        }
    }
}
