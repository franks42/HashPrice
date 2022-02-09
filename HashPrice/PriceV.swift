//
//  HPSpotV.swift
//  HashPrice
//
//  Created by Frank Siebenlist on 1/13/22.
//

import SwiftUI

struct PriceV: View {
  
  @ObservedObject var dlobState: DlobState
  
  var body: some View {
    
    HStack {
      VStack(alignment: .leading) {
        (
          Text("Hash")
            .font(.largeTitle)
          +
          Text(" Utility Token")
            .font(.title2)
        )
          .fontWeight(.bold)
          .multilineTextAlignment(.leading)
          .lineLimit(1)
          //.padding([.top, .leading, .trailing])
          .minimumScaleFactor(0.4)
        
        Text("Provenance Blockchain DLOB")
          .fontWeight(.bold)
          .multilineTextAlignment(.leading)
          .lineLimit(1)
          //.padding(.horizontal)
          .font(.body)
          .minimumScaleFactor(0.4)
        
        
        (
          Text(self.dlobState.xrate + " ")
            .font(Font.system(.largeTitle, design: .monospaced).monospacedDigit())
            .font(.largeTitle)
            .foregroundColor(.blue)
          +
          Text("[$/Hash]")
            .font(.body)
        )
          .fontWeight(.bold)
          .multilineTextAlignment(.leading)
          .lineLimit(1)
          .minimumScaleFactor(0.4)
          //.padding([.leading, .bottom])
      }
      Spacer()
    }
    .padding()
  }
}


struct PriceV_Previews: PreviewProvider {
  
  static var previews: some View {
    PriceV(dlobState: DlobState())
  }
}
