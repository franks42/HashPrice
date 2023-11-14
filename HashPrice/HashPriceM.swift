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
struct OrderBooksResponseOld: Codable {
  var contractAddress: String = ""
  var volumeTraded: String = ""
  var displayVolumeTraded: String = ""
  var highPricePerUnit: String = ""
  var highDisplayPricePerDisplayUnit: String = ""
  var lowPricePerUnit: String = ""
  var lowDisplayPricePerDisplayUnit: String = ""
  var latestPricePerUnit: String = ""
  var latestDisplayPricePerDisplayUnit: String = ""
  
  static func fetchDlobState() async -> OrderBooksResponseOld? {
    
    print("fetchDlobState - enter")
    
    guard let url = URL(string: "https://www.dlob.io/aggregator/external/api/v1/order-books/pb18vd8fpwxzck93qlwghaj6arh4p7c5n894vnu5g/daily-price")
    else {
      print("fetchDlobState: Invalid URL")
      return nil
    }
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      
      guard let decodedResponse = try? JSONDecoder().decode(OrderBooksResponseOld.self, from: data)
      else {
        print("fetchDlobState: Json Decoder problem!")
        return nil
      }
      print("fetchDlobState - successful exit")
      return decodedResponse
      
    } catch {
      print("fetchDlobState: Invalid data!!!")
      return nil
    }
  }
  
  
  static func fetchFakeDlobState() -> OrderBooksResponseOld {
    
    print("fetchFakeDlobState")
    
    let decodedResponse = OrderBooksResponseOld(
      contractAddress: "fakeit",
      volumeTraded:  "1000000000000000",
      displayVolumeTraded:  "1000000",
      highPricePerUnit:  "0.0000001500",
      highDisplayPricePerDisplayUnit:  "1.500",
      lowPricePerUnit:  "0.0000000100",
      lowDisplayPricePerDisplayUnit:  "0.100",
      latestPricePerUnit:  String(format: "%.9f", Double.random(in: 0.1 ..< 1.5)/10000000.0),
      latestDisplayPricePerDisplayUnit:  String(format: "%.3f", Double.random(in: 0.1 ..< 1.5))
    )
    return decodedResponse
  }
}
*/

/*
 This is the json array with the two ticker_id's returned
 from "https://www.dlob.io/gecko/external/api/v1/exchange/tickers":
 [
   {
     "ticker_id": "HASH_USD",
     "base_currency": "USD",
     "target_currency": "HASH",
     "last_price": 0.01,
     "base_volume": 0,
     "target_volume": 0,
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
     "base_volume": 0,
     "target_volume": 0,
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
  var base_volume:   Int64 = 0       // 0
  var target_volume: Int64 = 0       // 0
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
      base_volume:   0,
      target_volume: 0,
      bid:  0.007,
      ask:  0.01,
      high: 0.01,
      low:  0.0
      /*
      contractAddress: "fakeit",
      volumeTraded:  "1000000000000000",
      displayVolumeTraded:  "1000000",
      highPricePerUnit:  "0.0000001500",
      highDisplayPricePerDisplayUnit:  "1.500",
      lowPricePerUnit:  "0.0000000100",
      lowDisplayPricePerDisplayUnit:  "0.100",
      latestPricePerUnit:  String(format: "%.9f", Double.random(in: 0.1 ..< 1.5)/10000000.0),
      latestDisplayPricePerDisplayUnit:  String(format: "%.3f", Double.random(in: 0.1 ..< 1.5))
      */
    )
    return decodedResponse
  }
}
