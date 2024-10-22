//
//  ContentView.swift
//  Networking
//
//  Created by Nicolas Rios on 10/19/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CoinsViewModel()
    var body: some View {
        List {
            ForEach(viewModel.coins) { coin in
                Text(coin.name)
                HStack(spacing:12) {
                    Text("\(coin.marketCapRank)")
                        .foregroundColor(.gray)

                    VStack(alignment:.leading) {
                        Text(coin.name)
                            .fontWeight(.semibold)

                        Text(coin.symbol.uppercased())

                    }
                }
                .font(.footnote)
            }
        }
        .overlay {
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.footnote)

            }
        }

    }
}

#Preview {
    ContentView()
}
