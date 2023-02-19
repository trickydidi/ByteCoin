//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func updateCurrency(_ coinManager: CoinManager, currency: Double)
    func didFailWithError(error: Error)
    
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "7B20A6AE-1E03-4F2E-805F-DA2CB0CAD297"
    
    var delegate: CoinManagerDelegate?
    
    func fetchCurrency(currency: String) {
        let urlString = ("\(baseURL)/\(currency)?apikey=\(apiKey)")
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) { //create a URL
            let session = URLSession(configuration: .default) //create a url session
            let task = session.dataTask(with: url) { data, response, error in
               
                
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }

                if let safeData = data {
                    //print(String(data: safeData, encoding: .utf8))//turn swift data to a string
                    let decodedData = parseJSON(safeData)
                    delegate?.updateCurrency(self, currency: decodedData!)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print("last price: \(lastPrice)")
            return lastPrice
        } catch {
            print("error: \(error)")
            return nil
        }
    }
    
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
    }

    
}
