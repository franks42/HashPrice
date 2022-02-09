//
//  Volume24hV.swift
//  HashPrice
//
//  Created by Frank Siebenlist on 1/14/22.
//

import SwiftUI

struct VolumeView: View {
  
  @ObservedObject var dlobState: DlobState
  @Binding var utc24hChoice: Utc24h

  var body: some View {
    
    HStack {
      VStack(alignment: .leading) {
        
        if utc24hChoice == .H24 {
          Text("Volume - 24 Hour")
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .font(.title2)
            .minimumScaleFactor(0.4)
        } else {
          Text("Volume - UTC")
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .font(.title2)
            .minimumScaleFactor(0.4)
        }
        
        (
//          Text("Tokens:")
//          +
          Text(" " + dlobState.hashVolume + " ")
            .font(Font.system(.title2, design: .monospaced).monospacedDigit())
            .foregroundColor(.blue)
          +
          Text("[Hash/24h]")
        )
          .font(.body)
          .fontWeight(.bold)
          .multilineTextAlignment(.leading)
          .lineLimit(1)
          .minimumScaleFactor(0.4)
        
        (
//          Text("USD:        ")
//          +
          Text(" " + dlobState.usdVolume + " ")
            .font(Font.system(.title2, design: .monospaced).monospacedDigit())
            .foregroundColor(.blue)
          +
          Text("[$/24h]")
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








//struct Volume24hV_Previews: PreviewProvider {
//    static var previews: some View {
//        Volume24hV()
//    }
//}
