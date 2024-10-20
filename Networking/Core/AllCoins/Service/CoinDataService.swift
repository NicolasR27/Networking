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


    func fetchCoins(completion: @escaping ([Coin]) -> Void) {
  guard let url = URL(string: urlString) else { return }
     URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data else { return }

         guard  let coins = try? JSONDecoder().decode([Coin].self, from: data) else {
             return

         }
         for coin in coins {
             print("debug: \(coin.name)")
         }
         completion(coins)

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

            // Call the completion handler with the fetched price
            completion(price)
        }.resume()
    }
}
