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

    private let service = CoinDataService()

    init() {
        Task { await fetchCoins() }
    }

    @MainActor
    func fetchCoins() async {
        do {
            self.coins = try await service.fetchCoins()
        } catch{
            guard let error = error as? CoinAPIError else {return}
            self.errorMessage = error.customdescription

        }
    }

    func fetchCoinsWithCompletionHandler() {
        service.fetchCoinsWithResult { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case.success(let coins):
                        self?.coins = coins
                    case.failure(let error):
                        self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
