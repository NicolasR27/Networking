//
//  MockCoinService.swift
//  Networking
//
//  Created by Nicolas Rios on 11/8/24.
//

import Foundation
import SwiftUI

class MockCoinService: CoinServiceProtocol {
    func fetchCoins() async throws -> [Coin] {
        let bitcoin = Coin(id: "bitcoin", symbol: "btc", name: "Bitcoin", currentPrice: 2500, marketCapRank: 123456789)
        return [bitcoin]
    }

    func fetchCoinDetails(id: String) async throws -> CoinDetails? {
        let description = CoinDetails.Description(text: "test!340404")
        let bitcoinDetails = CoinDetails(id: "bitcoin", symbol: "btc", name: "Bitcoin", description: description)
        return bitcoinDetails
    }
}
