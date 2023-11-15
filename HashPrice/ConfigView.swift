//
//  ConfigView.swift
//  HashPrice
//
//  Created by Frank Siebenlist on 1/13/22.
//

import SwiftUI

struct EnumPicker<T: Hashable & CaseIterable, V: View>: View {
  
  @Binding var selected: T
  var title: String? = nil
  
  let mapping: (T) -> V
  
  var body: some View {
    Picker(selection: $selected, label: Text(title ?? "")) {
      ForEach(Array(T.allCases), id: \.self) {
        mapping($0).tag($0)
      }
    }
  }
}

extension EnumPicker where T: RawRepresentable, T.RawValue == String, V == Text {
  init(selected: Binding<T>, title: String? = nil) {
    self.init(selected: selected, title: title) {
      Text($0.rawValue)
    }
  }
}

enum Utc24h: String, CaseIterable {
  case UTC = "UTC"
  case H24 = "24H"
}

//

struct ConfigView: View {
  
  @ObservedObject var dlobState: DlobState
  @Binding var showConfigView: Bool
  @Binding var pollingTimeSec: Float
  @Binding var bgColor: Color
  @Binding var hashAmtS: String
    
  let minPollingTime: Float = 5.0
  let maxPollingTime: Float = 3600.0
  let pollingTimeStep: Float = 5.0
  
  var body: some View {
    
    ZStack {
      bgColor
        .ignoresSafeArea()
      
      ScrollView {
        
        VStack {
          HStack {
            
            Text("Hash Price Config")
              .font(.title3)
              .fontWeight(.bold)
            
            Spacer()
            
            Button(action: {showConfigView = false}) {
              Text("Done")
                .font(.title3)
                .fontWeight(.bold)
            }
            .buttonStyle(.bordered)
          }
          .padding()
          
          Spacer()
          
          PollingSliderView(pollingTimeSec: $pollingTimeSec)
          
          NotifyTimerSliderView(dlobState: dlobState)
                    
          VStack {
            ColorPicker(selection: $bgColor) {
              Button(action: {bgColor = Color(.sRGB, red:0.580, green:0.695, blue:1.000)}) {
                Text("Background Color")
                  .foregroundColor(.black)
              }
            }
          }
          .padding()
          .border(Color.green, width: 2)
          .padding([.leading, .bottom, .trailing])
          
          VStack {
            Text("Hash Portfolio [tokens]:")
            TextField("", text: Binding(
              get: {hashAmtS},
              set: {hashAmtS = $0.filter{"0123456789".contains($0)}}))
              .keyboardType(.decimalPad)
              .overlay(
                RoundedRectangle(cornerRadius: 8)
                  .stroke(lineWidth: 2)
                  .foregroundColor(.blue)
              )
          }
          .padding()
          .border(Color.green, width: 2)
          .padding([.leading, .bottom, .trailing])
          
          FakeRandomPriceToggleView(dlobState: dlobState)

          
          Spacer()
          
        }
      }
    }
  }
}

struct FakeRandomPriceToggleView: View {
  @ObservedObject var dlobState: DlobState
  
  var body: some View {
    HStack {
      Toggle(isOn: $dlobState.fakeRandomPrice) {
        Text("Fake/random prices")
      }
      .padding()
      .border(Color.green, width: 2)
    }
    .padding([.leading, .bottom, .trailing])
  }
}

struct PollingSliderView: View {
  
  @Binding var pollingTimeSec: Float
  @State private var isEditing = false
  
  let minPollingTime: Float = 5.0
  let maxPollingTime: Float = 3600.0
  let pollingTimeStep: Float = 5.0
  
  
  var body: some View {
    VStack {
      
      Text("Polling time [sec]: ")
      +
      Text(String(format: "%.0f", pollingTimeSec))
        .foregroundColor(isEditing ? .red : .blue)
      
      Slider(
        value: $pollingTimeSec,
        in: minPollingTime...maxPollingTime,
        step: pollingTimeStep
      ) {
        Text("Speed")
      } minimumValueLabel: {
        Text(String(format: "%.0f", minPollingTime))
      } maximumValueLabel: {
        Text(String(format: "%.0f", maxPollingTime))
      } onEditingChanged: { editing in
        isEditing = editing
      }
      .accentColor(Color.green)
    }
    .padding()
    .border(Color.green, width: 2)
    .padding([.leading, .bottom, .trailing])
  }
}


struct NotifyTimerSliderView: View {
  
  @ObservedObject var dlobState: DlobState
  
  @State private var isEditing = false
  
  let minPollingTime: Float = 5.0
  let maxPollingTime: Float = 60.0
  let pollingTimeStep: Float = 5.0
  
  
  var body: some View {
    VStack {
      
      Text("Notification timer [min]: ")
      +
      Text(String(format: "%.0f", dlobState.notificationTimerMin))
        .foregroundColor(isEditing ? .red : .blue)
      
      Slider(
        value: $dlobState.notificationTimerMin,
        in: minPollingTime...maxPollingTime,
        step: pollingTimeStep
      ) {
        Text("Speed")
      } minimumValueLabel: {
        Text(String(format: "%.0f", minPollingTime))
      } maximumValueLabel: {
        Text(String(format: "%.0f", maxPollingTime))
      } onEditingChanged: { editing in
        isEditing = editing
      }
      .accentColor(Color.green)
    }
    .padding()
    .border(Color.green, width: 2)
    .padding([.leading, .bottom, .trailing])
  }
}





//struct ConfigView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfigView()
//    }
//}

