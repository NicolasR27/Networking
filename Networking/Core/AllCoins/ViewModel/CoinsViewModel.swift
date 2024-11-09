//
//  CoinsViewModel.swift
//  Networking
//
//  Created by Nicolas Rios on 10/19/24.
//

import Foundation

class CoinsViewModel: ObservableObject {

    @Published var coins = [Coin]()
    @Published var errorMessage: String?
    @Published var coinDetails: CoinDetails?  // Singular: coinDetails

    private let service: CoinServiceProtocol

    init(service: CoinServiceProtocol) {
        self.service = service
        Task { await fetchCoins() }
    }

    @MainActor
    func fetchCoins() async {
        do {
            self.coins = try await service.fetchCoins()
        } catch {
            guard let error = error as? CoinAPIError else { return }
            self.errorMessage = error.customdescription
        }
    }

    @MainActor
    func fetchCoinDetails(coinid: String) async {
        do {
            self.coinDetails = try await service.fetchCoinDetails(id: coinid)  // Corrected to coinDetails
        } catch {
            guard let error = error as? CoinAPIError else { return }
            self.errorMessage = error.customdescription
        }
    }
}
