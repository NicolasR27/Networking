//
//  Coin.swift
//  Networking
//
//  Created by Nicolas Rios on 10/19/24.
//

import Foundation

struct Coin: Codable, Identifiable,Hashable{
    let id: String
    let symbol: String
    let name: String
    let currentPrice: Double
    let marketCapRank: Int

    enum CodingKeys: String, CodingKey {
        case id,symbol, name
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
    }

}
