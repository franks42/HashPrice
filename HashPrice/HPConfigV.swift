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

  
  var body: some View {
    HStack {

      Link(destination: URL(string: "https://github.com/franks42/HashPrice/wiki#what-is-this-hashprice-app-and-how-does-it-work")!) {
          Image(systemName: "info.circle")
              .font(.title3)
      }
      
      Spacer()
      
      Link("Provenance Blockchain Foundation",
           destination: URL(string: "https://provenance.io")!)
          .font(.title3)
          .lineLimit(1)
          .minimumScaleFactor(0.4)
      
      Spacer()
      
      Button(action: { showConfigView = true }) {
        Image(systemName: "gear")
      }
      .font(.title3)
      .fullScreenCover(
        isPresented: $showConfigView,
        content: {
          ConfigView(dlobState: dlobState,
                     showConfigView: $showConfigView,
                     pollingTimeSec: $pollingTimeSec,
                     bgColor: $bgColor,
                     hashAmtS: $hashAmtS
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
              hashAmtS: .constant("123"))
  }
}
