//
//  HashPriceM.swift
//  HashPrice
//
//  Created by Frank Siebenlist on 1/13/22.
//

import Foundation

extension Int {
  func withCommas() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    return numberFormatter.string(from: NSNumber(value:self))!
  }
}

extension Int64 {
  func withCommas() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    return numberFormatter.string(from: NSNumber(value:self))!
  }
}

/*
 This is the json array with the two ticker_id's returned
 from "https://www.dlob.io/gecko/external/api/v1/exchange/tickers":
 [
   {
     "ticker_id": "HASH_USD",
     "base_currency": "USD",
     "target_currency": "HASH",
     "last_price": 0.01,
     "base_volume": 0.0,
     "target_volume": 0.0,
     "bid": 0.007,
     "ask": 0.01,
     "high": 0.01,
     "low": 0.01
   },
   {
     "ticker_id": "HASH_USDOMNI",
     "base_currency": "USDOMNI",
     "target_currency": "HASH",
     "last_price": 0.007,
     "base_volume": 0.0,
     "target_volume": 0.0,
     "bid": 0.007,
     "ask": 0.012,
     "high": 0.007,
     "low": 0.007
   }
 ]
 */


struct OrderBooksResponse: Codable {
  var ticker_id:      String = ""    // "HASH_USD" or "HASH_USDOMNI"
  var base_currency:   String = ""   // "USD" or "USDOMNI"
  var target_currency: String = ""   // "HASH"
  var last_price:    Double = 0.0    // 0.01
  var base_volume:   Double = 0.0    // 0.0
  var target_volume: Double = 0.0    // 0.0
  var bid:  Double = 0.0           // 0.007
  var ask:  Double = 0.0           // 0.01
  var high: Double = 0.0           // 0.01
  var low:  Double = 0.0           // 0.01

  static func fetchDlobState() async -> [OrderBooksResponse]? {
    
    print("fetchDlobState - enter")
    
    guard let url = URL(string: "https://www.dlob.io/gecko/external/api/v1/exchange/tickers")
    else {
      print("fetchDlobState: Invalid URL")
      return nil
    }
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      
      guard let decodedResponse = try? JSONDecoder().decode([OrderBooksResponse].self, from: data)
      else {
        print("fetchDlobState: Json Decoder problem!")
        return nil
      }
      // ensure that we have a list of responses that includes at least the "HASH_USD" ticker_id
      for tickerResponse in decodedResponse {
        if tickerResponse.ticker_id == "HASH_USD" {
          print("fetchDlobState - successful exit")
          return decodedResponse
        }
      }
      print("fetchDlobState: decodedResponse array has no HASH_USD ticker_id item")
      return nil
    } catch {
      print("fetchDlobState: Invalid data!!!")
      return nil
    }
  }
  
  
  static func fetchFakeDlobState() -> OrderBooksResponse {
    
    print("fetchFakeDlobState")
    
    let decodedResponse = OrderBooksResponse(
      ticker_id: "HASH_USD",
      base_currency: "USD",
      target_currency: "HASH",
      last_price:    Double.random(in: 0.1 ..< 1.5),
      base_volume:   0.0,
      target_volume: 0.0,
      bid:  0.007,
      ask:  0.01,
      high: 0.01,
      low:  0.0
    )
    return decodedResponse
  }
}
