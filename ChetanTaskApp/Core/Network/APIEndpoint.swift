//
//  APIEndpoint.swift
//  ChetanTaskApp
//
//  Created by Chetan Rajauria on 09/07/25.
//

import Foundation

enum APIEndpoint {
    case fetchHoldings

    var url: URL {
        switch self {
        case .fetchHoldings:
            return makeURL(path: "")
        }
    }

    private func makeURL(path: String, queryItems: [URLQueryItem] = []) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io"
        components.path = "/" + path
        components.queryItems = queryItems

        guard let url = components.url else {
            fatalError("Invalid URL")
        }
        return url
    }
}
