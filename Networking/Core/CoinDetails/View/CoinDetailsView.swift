//
//  CoinDetailView.swift
//  Networking
//
//  Created by Nicolas Rios on 10/21/24.
//
//

import SwiftUI

struct CoinDetailsView: View {
    let coin: Coin
    @ObservedObject var viewmodel: CoinDetailsViewModel


    init(coin: Coin) {
        self.coin = coin
        self.viewmodel = CoinDetailsViewModel(coinId: coin.id)
    }

    var body: some View {
        VStack(alignment: .leading) {
            if let details = viewmodel.coinDetails {
                Text(details.name)
                    .fontWeight(.bold)
                    .font(.subheadline)

                Text(details.symbol.uppercased())
                    .font(.footnote)

                Text(details.description.text)
                    .font(.footnote)
                    .padding(.vertical)
            }
        }
        .task{
            await viewmodel.fetchCoinDetails()
        }

        .padding()

    }
}
