//
//  PriceWV.swift
//  HashPriceWidgetExtension
//
//  Created by Frank Siebenlist on 1/18/22.
//

//
//  HPSpotV.swift
//  HashPrice
//
//  Created by Frank Siebenlist on 1/13/22.
//

import SwiftUI

//@MainActor class DlobWState: ObservableObject {
class DlobWState: ObservableObject {
  
  @Published var xrate: String = "0.666"
  @Published var hxrate: String = "1.000"
  @Published var lxrate: String = "0.111"
  @Published var hashVolume: String = "1,111,111"
  @Published var usdVolume: String = "222,222"
  @Published var dateStamp: String = "00/00/0000"
  @Published var timeStamp: String = "00:00:00"
  
  @Published var askxrate: String = "0.666"
  @Published var bidxrate: String = "0.666"

  @Published var hashOmniVolume: String = "1,111,111"
  @Published var usdOmniVolume: String = "222,222"

  @Published var hashAssets: Int = 1234567
  @Published var fakeRandomPrice: Bool = false
  @Published var notificationTimerMin: Float = 5
  
  //
  
  static var theDlobWState: DlobWState? = nil
  var previousPricePerUnit_usd_hash_badge: Int = 0
  var previous_xrate = ""
  
  
  static func getDlobState() -> DlobWState {
    if theDlobWState == nil { theDlobWState = DlobWState()}
    return theDlobWState!
  }
  
  // methods
  
  
  func updateDlobState() async {
    print("updateDlobWState - enter")
    
    var decodedResponse1: [OrderBooksResponse]? = nil
    
    if !self.fakeRandomPrice {
      
      decodedResponse1 = await OrderBooksResponse.fetchDlobState()
      
      guard decodedResponse1 != nil else {
        print("updateDlobWState - decodedResponse1 == nil")
        return
      }
      
    } else {
      
      decodedResponse1 = [OrderBooksResponse.fetchFakeDlobState()]
      
    }
    
    print("updateDlobWState - fakeRandomPrice:", fakeRandomPrice)
    
    let decodedResponse2 : [OrderBooksResponse]! = decodedResponse1
    
    for decodedResponse in decodedResponse2 {
      
      if decodedResponse.ticker_id == "HASH_USD" {
        let latestPricePerUnit_usd_hash = decodedResponse.last_price
        let lowPricePerUnit_usd_hash = decodedResponse.low
        let highPricePerUnit_usd_hash = decodedResponse.high
        let latestAskPricePerUnit_usd_hash = decodedResponse.ask
        let latestBidPricePerUnit_usd_hash = decodedResponse.bid
        let volumeTraded_hash = decodedResponse.target_volume
        let volumeTraded_usd = decodedResponse.base_volume

        self.xrate = String(format: "%.3f", latestPricePerUnit_usd_hash)
        self.hxrate = String(format: "%.3f", highPricePerUnit_usd_hash)
        self.lxrate = String(format: "%.3f", lowPricePerUnit_usd_hash)
        self.hashVolume = volumeTraded_hash.withCommas()
        self.usdVolume = Int(volumeTraded_usd).withCommas()
        
        self.askxrate = String(format: "%.3f", latestAskPricePerUnit_usd_hash)
        self.bidxrate = String(format: "%.3f", latestBidPricePerUnit_usd_hash)

      } else {
        if decodedResponse.ticker_id == "HASH_USDOMNI" {
          let volumeTraded_hash = decodedResponse.target_volume
          let volumeTraded_usd = decodedResponse.base_volume
          self.hashOmniVolume = volumeTraded_hash.withCommas()
          self.usdOmniVolume = Int(volumeTraded_usd).withCommas()
        }
      }
    }
    
    print("updateDlobWState - false - self.xrate:", self.xrate)

    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    let now = Date()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    timeFormatter.dateFormat = "HH:mm:ss"
    self.dateStamp = dateFormatter.string(from: now)
    self.timeStamp = timeFormatter.string(from: now)
    
  }
}



struct PriceWV: View {
  
  @ObservedObject var dlobState: DlobWState
  
  var body: some View {
    
    //    HStack {
    VStack(alignment: .leading) {
      HStack {
        Image("hash-logo-16x16")
          .aspectRatio(contentMode: .fill)
          .scaledToFit()
        (
          Text("$")
            .font(.title)
          +
          Text(self.dlobState.xrate)
            .font(Font.system(.title, design: .monospaced).monospacedDigit())
            .font(.title)
            .foregroundColor(.blue)
        )
      }
      .multilineTextAlignment(.leading)
      .lineLimit(1)
      .minimumScaleFactor(0.2)
      
      (
        Text("Hash")
          .font(.title)
        +
        Text(" Utility Token")
          .font(.title2)
      )
        .fontWeight(.bold)
        .multilineTextAlignment(.leading)
        .lineLimit(1)
      //.padding([.top, .leading, .trailing])
        .minimumScaleFactor(0.4)
            
      (
        Text("H/L:")
        +
        Text(" " + dlobState.hxrate)
          .font(Font.system(.title3, design: .monospaced).monospacedDigit())
          .foregroundColor(.blue)
        +
        Text(" / ")
          .font(.body)
          .fontWeight(.bold)
        +
        Text(dlobState.lxrate + " ")
          .font(Font.system(.title3, design: .monospaced).monospacedDigit())
          .foregroundColor(.blue)
      )
        .font(.body)
        .fontWeight(.bold)
        .multilineTextAlignment(.leading)
        .lineLimit(1)
        .minimumScaleFactor(0.2)
      //          .padding([.top, .bottom])
      (
        Text("V:")
        +
        Text(" " + dlobState.hashVolume)
          .font(Font.system(.title3, design: .monospaced).monospacedDigit())
          .foregroundColor(.blue)
        +
        Text(" / ")
          .font(.body)
          .fontWeight(.bold)
        +
        Text("$")
          .font(Font.system(.title3, design: .monospaced).monospacedDigit())
        +
        Text(dlobState.usdVolume)
          .font(Font.system(.title3, design: .monospaced).monospacedDigit())
          .foregroundColor(.blue)
      )
        .font(.body)
        .fontWeight(.bold)
        .multilineTextAlignment(.leading)
        .lineLimit(1)
        .minimumScaleFactor(0.2)
    }
    .padding([.leading, .trailing])
  }
}


//struct PriceWV_Previews: PreviewProvider {
//  @ObservedObject var dlobState: DlobWState
//    static var previews: some View {
//        PriceWV(dlobState: dlobState)
//    }
//}
