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
        VStack {
            Text("\(viewModel.coin):\(viewModel.price)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
