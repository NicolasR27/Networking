import SwiftUI

struct ContentView: View {

    private let service: CoinServiceProtocol
    @StateObject private var viewModel: CoinsViewModel

    init(service: CoinServiceProtocol) {
        self.service = service
        self._viewModel = StateObject(wrappedValue: CoinsViewModel(service: service)) // Pass the service instance
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
                // Create the CoinDetailsViewModel and pass it to CoinDetailsView
                let coinDetailsViewModel = CoinDetailsViewModel(coinId: coin.id, service: service)
              
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
