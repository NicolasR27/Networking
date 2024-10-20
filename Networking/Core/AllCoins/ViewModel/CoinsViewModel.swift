//
//  CoinsViewModel.swift
//  Networking
//
//  Created by Nicolas Rios on 10/19/24.
//

import Foundation

class CoinsViewModel: ObservableObject {

  @Published var coins: [Coin] = []

    private let service = CoinDataService()

    init() {
      fetchCoins()

        func fetchCoins() {
            service.fetchCoins { coins in
                DispatchQueue.main.async {
                    self.coins = coins

                }
            }
            }
        }

    }

