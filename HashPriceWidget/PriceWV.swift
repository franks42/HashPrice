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
    
    var decodedResponse1: OrderBooksResponse? = nil
    
    if !self.fakeRandomPrice {
      
      decodedResponse1 = await OrderBooksResponse.fetchDlobState()
      
      guard decodedResponse1 != nil else {
        print("updateDlobWState - decodedResponse1 == nil")
        return
      }
      
    } else {
      
      decodedResponse1 = OrderBooksResponse.fetchFakeDlobState()
      
    }
    
    let decodedResponse: OrderBooksResponse! = decodedResponse1
    
    print("updateDlobWState - fakeRandomPrice:", fakeRandomPrice)
    
    
    let latestPricePerUnit_usd_hash = (Double(decodedResponse.latestPricePerUnit) ?? 0.0) * 10000000
    let lowPricePerUnit_usd_hash = (Double(decodedResponse.lowPricePerUnit) ?? 0.0) * 10000000
    let highPricePerUnit_usd_hash = (Double(decodedResponse.highPricePerUnit) ?? 0.0) * 10000000
    let volumeTraded_hash = (Int64(decodedResponse.volumeTraded) ?? 0) / 1000000000
    let volumeTraded_usd = Double(volumeTraded_hash) * (highPricePerUnit_usd_hash + lowPricePerUnit_usd_hash)/2.0
    self.xrate = String(format: "%.3f", latestPricePerUnit_usd_hash)
    self.hxrate = String(format: "%.3f", highPricePerUnit_usd_hash)
    self.lxrate = String(format: "%.3f", lowPricePerUnit_usd_hash)
    self.hashVolume = volumeTraded_hash.withCommas()
    self.usdVolume = Int(volumeTraded_usd).withCommas()
    print("updateDlobWState - false - self.xrate:", self.xrate)
    
    let timeFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    let now = Date()
    //HH:mm:ss MM/dd/yyyy
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
