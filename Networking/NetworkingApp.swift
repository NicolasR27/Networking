//
//  NetworkingApp.swift
//  Networking
//
//  Created by Nicolas Rios on 10/19/24.
//

import SwiftUI

@main
struct NetworkingApp: App {
//    @StateObject var viewmodel = CoinsViewModel(service: CoinDataService())
    var body: some Scene {
        WindowGroup {
            ContentView(service: MockCoinService())
//                .environmentObject(viewmodel)
        }
    }
}
