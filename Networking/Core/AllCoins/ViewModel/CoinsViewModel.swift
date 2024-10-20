//
//  CoinsViewModel.swift
//  Networking
//
//  Created by Nicolas Rios on 10/19/24.
//

import Foundation

class CoinsViewModel: ObservableObject {

    @Published var coin = ""
    @Published var price = ""

    init() {
        fetchPrice(coin: "litecoin")
    }
    func fetchPrice(coin: String) {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=(coin)vs_currencies=usd"
        guard let url = URL(string:urlString) else {return}

        print("fetching price..")

        URLSession.shared.dataTask(with: url) { data,response,  error in
            guard let data else { return }
            guard let jsonobject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {return}
            guard let value = jsonobject[coin] as? [String: Double] else {return}
            guard let price = value["usd"] else {return}

            DispatchQueue.main.async {
                self.coin =  coin.capitalized
                self.price = "$\(price)"
            }

        }.resume()

        print("did finish end of function")
    }

}
