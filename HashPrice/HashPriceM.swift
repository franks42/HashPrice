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


struct OrderBooksResponse: Codable {
  var contractAddress: String = ""
  var volumeTraded: String = ""
  var displayVolumeTraded: String = ""
  var highPricePerUnit: String = ""
  var highDisplayPricePerDisplayUnit: String = ""
  var lowPricePerUnit: String = ""
  var lowDisplayPricePerDisplayUnit: String = ""
  var latestPricePerUnit: String = ""
  var latestDisplayPricePerDisplayUnit: String = ""
  
  static func fetchDlobState() async -> OrderBooksResponse? {
    
    print("fetchDlobState - enter")
    
    guard let url = URL(string: "https://www.dlob.io/aggregator/external/api/v1/order-books/pb18vd8fpwxzck93qlwghaj6arh4p7c5n894vnu5g/daily-price")
    else {
      print("fetchDlobState: Invalid URL")
      return nil
    }
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      
      guard let decodedResponse = try? JSONDecoder().decode(OrderBooksResponse.self, from: data)
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
  
  
  static func fetchFakeDlobState() -> OrderBooksResponse {
    
    print("fetchFakeDlobState")
    
    let decodedResponse = OrderBooksResponse(
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

