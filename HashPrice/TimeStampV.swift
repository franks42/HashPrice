//
//  TimeStampV.swift
//  HashPrice
//
//  Created by Frank Siebenlist on 1/14/22.
//

import SwiftUI

struct TimeStampV: View {
  
  @ObservedObject var dlobState: DlobState

  var body: some View {
    
    HStack {
      VStack(alignment: .leading) {
        
        Text("Last Update")
          .fontWeight(.bold)
          .multilineTextAlignment(.leading)
          .lineLimit(1)
          .font(.title2)
          .minimumScaleFactor(0.4)
        
        
        (
          Text(dlobState.dateStamp + " ")
            .font(Font.system(.title2, design: .monospaced).monospacedDigit())
            .foregroundColor(.blue)
          +
          Text("at ")
            .font(.body)
            .fontWeight(.bold)
          +
          Text(" " + dlobState.timeStamp + " ")
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


//struct TimeStampV_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeStampV()
//    }
//}
