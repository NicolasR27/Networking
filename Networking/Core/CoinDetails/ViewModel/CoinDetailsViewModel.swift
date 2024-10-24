//
//  CoinDetailsViewModel.swift
//  Networking
//
//  Created by Nicolas Rios on 10/21/24.
//

import Foundation

class CoinDetailsViewModel: ObservableObject {

    private let service = CoinDataService()
    private let coinId: String

    @Published var coinDetails: CoinDetails?

    init(coinId: String) {
        self.coinId = coinId

//        Task { await fetchCoinDetails() }
    }

    @MainActor
    func fetchCoinDetails() async {
        do {
            self.coinDetails = try await service.fetchCoinDetails(id: coinId)
          
        } catch {
            print("DEBUG: Error fetching coin details: \(error.localizedDescription)")
        }
    }
}
