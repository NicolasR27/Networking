//
//  ContentView.swift
//  Networking
//
//  Created by Nicolas Rios on 10/19/24.
//
import SwiftUI

struct ContentView: View {

    private let serivce: CoinDataService
    @StateObject var viewModel: CoinsViewModel

    init(service:CoinDataService) {
        self.serivce = service
        self._viewModel = StateObject(wrappedValue:CoinsViewModel(service: service))

    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.coins) { coin in
                    NavigationLink(value: coin) {
                        HStack(spacing: 12) {
                            Text("\(coin.marketCapRank)")
                                .foregroundColor(.gray)

                            VStack(alignment: .leading) {
                                Text(coin.name)
                                    .fontWeight(.semibold)

                                Text(coin.symbol.uppercased())
                            }
                        }
                        .font(.footnote)
                    }
                }
            }
            .navigationDestination(for: Coin.self) { coin in
                CoinDetailsView(coin: coin,service: serivce)
            }
            .overlay {
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .padding()
                        .multilineTextAlignment(.center)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
    }
}

#Preview {
    ContentView(service: CoinDataService())
}
