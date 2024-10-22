//
//  CoinDataService.swift
//  Networking
//
//  Created by Nicolas Rios on 10/19/24.
//

import Foundation

class CoinDataService {

    private let urlString =
    "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=38&page=1&sparkline=false&price_change_percentage=24h&locale=en"

    func fetchCoins() async throws -> [Coin] {
        guard let url = URL(string: urlString) else { return [] }
        let (data,response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw CoinAPIError.requestFailed(description: "Request Failed")

        }

        guard httpResponse.statusCode == 200 else {
            throw CoinAPIError.invalidStatusCode(statusCode: httpResponse.statusCode)
        }

        do {
        let coins = try JSONDecoder().decode([Coin].self, from: data)
            return coins
        } catch let error {
            print("DEBUG: Error \(error)")
            throw error as? CoinAPIError ?? .unknownError(error: error)
        }
    }

    func fetchCoinsWithResult(completion: @escaping (Result<[Coin], CoinAPIError>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.unknownError(error: error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "Request Failed")))
                return
            }

            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidStatusCode(statusCode: httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                completion(.success(coins))
            } catch {
                print("DEBUG: Failed to decode error: \(error)")
                completion(.failure(.JSONParsingFailure))
            }

        }.resume()
    }

    func fetchCoins(completion: @escaping ([Coin]?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else { return }

            guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else {
                return
            }

            // Remove this print if you are seeing double logs
            for coin in coins {
                print("DEBUG: \(coin.name)")
            }
            completion(coins, nil)

        }.resume()
    }

    func fetchPrice(coin: String, completion: @escaping (Double) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("DEBUG FAILED with error \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }

            guard httpResponse.statusCode == 200 else {
                print("Failed to fetch with status code \(httpResponse.statusCode)")
                return
            }

            guard let data = data else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            guard let value = jsonObject[coin] as? [String: Double] else { return }
            guard let price = value["usd"] else { return }

            completion(price)
        }.resume()
    }
}
