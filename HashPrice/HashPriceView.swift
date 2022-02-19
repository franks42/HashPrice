//
//  ContentView.swift
//  HashPrice
//
//  Created by Frank Siebenlist on 1/13/22.
//

import SwiftUI
import Foundation

struct HashPriceView: View {
  
  //  @StateObject var dlobState = DlobState()
  @ObservedObject var dlobState: DlobState
  
  @State private var showConfigView = false
  @State var pollingTimeSec: Float = 5*60
  
  //  @State private var bgColor: Color = Color(.sRGB, red: 0.65, green: 0.88, blue: 0.98)
  //  @State private var bgColor: Color =  Color(UIColor(red:0.580, green:0.695, blue:1.000, alpha:1.00))
  //  The Color of Infinite Temperature
  //  https://johncarlosbaez.wordpress.com/2022/01/16/the-color-of-infinite-temperature/
  //  The color he got is sRGB(148,177,255).
  //  And according to the experts who sip latte all day and make up names for colors,
  //  this color is called ‘Perano’.
  //  rgb(148,177,255)
  //  [NSColor colorWithCalibrated Red:0.580 green:0.695 blue:1.000 alpha:1.00]
  //  [UIColor colorWithRed:0.580 green:0.695 blue:1.000 alpha:1.00]
  //  #93b1fe
//  @State private var bgColor: Color =  Color(.sRGB, red:0.580, green:0.695, blue:1.000)
  @AppStorage("bgColor") var bgColor: Color =  Color(red:0.580, green:0.695, blue:1.000)
  
//  @State private var hashAmtS: String = "0"
  @AppStorage("hashAmtS") private var hashAmtS: String = "0"
  
  var body: some View {
    
    ZStack {
      bgColor
        .ignoresSafeArea()
      
      VStack {
        
        ScrollView {
          
          VStack {
            
            PriceV(dlobState: dlobState)
              .onTapGesture {
                DispatchQueue.main.async {
                  Task {
                    await dlobState.updateDlobState()
                  }
                }
              }
            
            TimeStampV(dlobState: dlobState)
            
            Price24hView(dlobState: dlobState)
            
            VolumeView(dlobState: dlobState)
            
            HashPortfolioV(hashAmtS: $hashAmtS, dlobState: dlobState)
            
          }
          .padding()
        }
        .onAppear {
          //        Task {
          DispatchQueue.main.async {
            Task {
              // await dlobState.fetchDlobState()
              await dlobState.updateDlobState()
            }
          }
          self.repeatLoadData()
        }
        .environmentObject(self.dlobState)
        
        Spacer()
        
        HPConfigV(
          dlobState: dlobState,
          showConfigView: $showConfigView,
          pollingTimeSec: $pollingTimeSec,
          bgColor: $bgColor,
          hashAmtS: $hashAmtS
        )
        
      }
    }
    
  }
  
  @Sendable func repeatLoadData() {
    Task {
      //      try await Task.sleep(nanoseconds: 5_000_000_000)
      try await Task.sleep(nanoseconds: (UInt64(pollingTimeSec) * 1000000000))
      if Task.isCancelled {
        print("Cancelled")
      }
      else
      {
        await dlobState.updateDlobState()
        repeatLoadData()
      }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    
    Group {
      
      HashPriceView(dlobState: DlobState())
      
      PriceV(dlobState: DlobState())
      
    }

  }
}
