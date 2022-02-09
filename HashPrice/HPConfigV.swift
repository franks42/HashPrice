//
//  HPConfigV.swift
//  HashPrice
//
//  Created by Frank Siebenlist on 1/13/22.
//

import SwiftUI


struct HPConfigV: View {
  
  @ObservedObject var dlobState: DlobState
  @Binding var showConfigView: Bool
  @Binding var pollingTimeSec: Float
  @Binding var bgColor: Color
  @Binding var hashAmtS: String
  @Binding var utc24hChoice: Utc24h

  
  var body: some View {
    HStack {
      Image(systemName: "info.circle")
      Spacer()
      Text("Provenance Blockchain Foundation")
        .font(.body)
        .lineLimit(1)
        .minimumScaleFactor(0.4)
      Spacer()
      Button(action: { showConfigView = true }) {
        Image(systemName: "gear")
      }
      .fullScreenCover(
        isPresented: $showConfigView,
        content: {
          ConfigView(dlobState: dlobState,
                     showConfigView: $showConfigView,
                     pollingTimeSec: $pollingTimeSec,
                     bgColor: $bgColor,
                     hashAmtS: $hashAmtS,
                     utc24hChoice: $utc24hChoice
          )})
      
    }
    .padding()
    .overlay(
      RoundedRectangle(cornerRadius: 16)
        .stroke(Color.blue, lineWidth: 2)
    )
    //        .border(Color.black)
  }
}

struct HPConfigV_Previews: PreviewProvider {
  
  static var previews: some View {
    
    HPConfigV(dlobState: DlobState(), showConfigView: .constant(true), pollingTimeSec: .constant(10), bgColor: .constant(Color.gray),
              hashAmtS: .constant("123"),
              utc24hChoice: .constant(Utc24h.H24))
  }
}
