//
//  HTTDataDownloader.swift
//  Networking
//
//  Created by Nicolas Rios on 10/23/24.
//

import Foundation

protocol HTTDataDownloader {
    func fetchData<T: Decodable>(as type: T.Type, endpoint: String) async throws -> T
}

extension HTTDataDownloader {
    func fetchData<T: Decodable>(as type: T.Type, endpoint: String) async throws -> T {
        guard let url = URL(string: endpoint) else {
            throw CoinAPIError.requestFailed(description: "Invalid URL")
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CoinAPIError.invalidStatusCode(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }

        do {
            return try JSONDecoder().decode(type, from: data)
        } catch let error {
            print("DEBUG: Error decoding data: \(error)")
            throw CoinAPIError.JSONParsingFailure
        }
    }
}
