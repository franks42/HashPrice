//
//  Price24hV.swift
//  HashPrice
//
//  Created by Frank Siebenlist on 1/14/22.
//

import SwiftUI

struct Price24hView: View {
  
  @ObservedObject var dlobState: DlobState

  var body: some View {
    
    HStack {
      VStack(alignment: .leading) {
        
        Text("Price - 24 Hour")
          .fontWeight(.bold)
          .multilineTextAlignment(.leading)
          .lineLimit(1)
          .font(.title2)
          .minimumScaleFactor(0.4)
        
        (
          Text("High:")
          +
          // Text(hxrate + " / " + lxrate + " ")
          Text(" " + dlobState.hxrate + " ")
            .font(Font.system(.title2, design: .monospaced).monospacedDigit())
            .foregroundColor(.blue)
          +
          Text("[$/Hash]")
        )
          .font(.body)
          .fontWeight(.bold)
          .multilineTextAlignment(.leading)
          .lineLimit(1)
          .minimumScaleFactor(0.4)
        (
          Text("Low: ")
          +
          // Text(hxrate + " / " + lxrate + " ")
          Text(" " + dlobState.lxrate + " ")
            .font(Font.system(.title2, design: .monospaced).monospacedDigit())
            .foregroundColor(.blue)
          +
          Text("[$/Hash]")
        )
          .font(.body)
          .fontWeight(.bold)
          .multilineTextAlignment(.leading)
          .lineLimit(1)
          .minimumScaleFactor(0.4)
      }
      Spacer()
    }
    .padding()
  }
}


//struct Price24hV_Previews: PreviewProvider {
//    static var previews: some View {
//      Price24hView()
//    }
//}
