//
//  HashHoldingsV.swift
//  HashPrice
//
//  Created by Frank Siebenlist on 1/14/22.
//

import SwiftUI

struct HashPortfolioV: View {
  
  @Binding var hashAmtS: String
  @ObservedObject var dlobState: DlobState

  var body: some View {
    
    HStack {
      VStack(alignment: .leading) {
        
        Text("Hash Portfolio")
          .fontWeight(.bold)
          .multilineTextAlignment(.leading)
          .lineLimit(1)
          .font(.title2)
          .minimumScaleFactor(0.4)
        
        
        (
//          Text(hashAmtS)
//            .font(Font.system(.title2, design: .monospaced).monospacedDigit())
//            .foregroundColor(.blue)
//          +
//          Text(" [tokens] : $")
//            .font(.body)
//            .fontWeight(.bold)
//          +
//          Text("USD: ")
          Text("$ ")
            .font(.title2)
            .fontWeight(.bold)
          +
          Text(String(Int64(Float("0"+hashAmtS)! * Float("0"+dlobState.xrate)!).withCommas()))
            .font(Font.system(.title2, design: .monospaced).monospacedDigit())
            .foregroundColor(.blue)
        )
          .font(.body)
          .fontWeight(.bold)
          .multilineTextAlignment(.leading)
          .lineLimit(1)
          .minimumScaleFactor(0.4)
      }
      Spacer()
    }
    .padding(.horizontal)

  }
}












//struct HashHoldingsV_Previews: PreviewProvider {
//    static var previews: some View {
//        HashHoldingsV()
//    }
//}
