//
//  CoinDataService.swift
//  Networking
//
//  Created by Nicolas Rios on 10/19/24.
//

import Foundation

class CoinDataService: HTTDataDownloader {

    func fetchCoins() async throws -> [Coin] {
        guard let urlString = allCoinsURLString else {
            throw CoinAPIError.requestFailed(description: "Invalid URL")
        }
        print("DEBUG: Fetch Coins URL - \(urlString)")  // Debugging statement
        return try await fetchData(as: [Coin].self, endpoint: urlString)
    }

    func fetchCoinDetails(id: String) async throws -> CoinDetails? {
         if let cached = CoinDetailsCache.shared.get(forKey: id) {
             print ("DEBUG: Fetching from cache")
             return cached
        }
        guard let enpoint = cointDetailsURLString(id: id) else {
            throw CoinAPIError.requestFailed(description: "Invalid URL")
        }
        print("DEBUG: Fetch Coin Details URL - \(enpoint)")  // Debugging statement

        let details = try await fetchData(as: CoinDetails.self, endpoint: enpoint)
        CoinDetailsCache.shared.set(details, forKey: id)

        return details

    }


    private var baseUrlcomponent: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coingecko.com"
        components.path = "/api/v3/coins/markets"
        return components
    }

    private var allCoinsURLString: String? {
        var components = baseUrlcomponent
        components.queryItems = [
            .init(name: "vs_currency", value: "usd"),
            .init(name: "order", value: "market_cap_desc"),
            .init(name: "per_page", value: "20"),
            .init(name: "page", value: "1"),
            .init(name: "price_change_percentage", value: "24h")
        ]
        return components.url?.absoluteString
    }

    private func cointDetailsURLString(id: String) -> String? {
        var components = baseUrlcomponent
        components.path = "/api/v3/coins/\(id)"  // Updated the path to include the correct prefix

        components.queryItems = [
            .init(name: "localization", value: "false")
        ]
        return components.url?.absoluteString
    }



    // MARK: - Completion Handler Methods

    func fetchCoinsWithResult(completion: @escaping (Result<[Coin], CoinAPIError>) -> Void) {
        guard let urlString = allCoinsURLString, let url = URL(string: urlString) else {
            completion(.failure(.requestFailed(description: "Invalid URL")))
            return
        }

        print("DEBUG: Fetch Coins URL - \(urlString)")  // Debugging statement

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.unknownError(error: error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "Invalid HTTP Response")))
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
        guard let urlString = allCoinsURLString, let url = URL(string: urlString) else {
            print("DEBUG: Invalid URL")
            return
        }

        print("DEBUG: Fetch Coins URL - \(urlString)")  // Debugging statement

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                print("DEBUG: No Data")
                return
            }

            guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else {
                print("DEBUG: Decoding failed")
                return
            }

            completion(coins, nil)
        }.resume()
    }

    func fetchPrice(coin: String, completion: @escaping (Double) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
        guard let url = URL(string: urlString) else {
            print("DEBUG: Invalid URL")
            return
        }

        print("DEBUG: Fetch Price URL - \(urlString)")  // Debugging statement

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("DEBUG FAILED with error \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("DEBUG: Invalid HTTP Response")
                return
            }

            guard httpResponse.statusCode == 200 else {
                print("DEBUG: Invalid status code: \(httpResponse.statusCode)")
                return
            }

            guard let data = data else {
                print("DEBUG: No Data")
                return
            }

            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let value = jsonObject[coin] as? [String: Double],
                  let price = value["usd"] else {
                print("DEBUG: Parsing JSON Failed")
                return
            }

            completion(price)
        }.resume()
    }
}
