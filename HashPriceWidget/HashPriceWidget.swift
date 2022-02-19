//
//  HashPriceWidget.swift
//  HashPriceWidget
//
//  Created by Frank Siebenlist on 1/17/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  
  static var dlobState: DlobWState? = nil
  
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), dlobState: DlobWState())
  }
  
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), dlobState: DlobWState())
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    print("getTimeline - enter")
    Task {
      do {
        print("getTimeline - do")
        if Provider.dlobState == nil {
          Provider.dlobState = DlobWState()
        }
        
        await Provider.dlobState!.updateDlobState()
        
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        //    await dlobState.updateDlobState()
        
        let secondOffset = 15*60
        //      let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate)!
        let renewDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate)!
        let entry = SimpleEntry(date: currentDate, dlobState: Provider.dlobState!)
        entries.append(entry)
        
        //      let timeline = Timeline(entries: entries, policy: .atEnd)
        let timeline = Timeline(entries: entries, policy: .after(renewDate))
        completion(timeline)
        print("getTimeline - completion")

      }
    }
  }
}


struct SimpleEntry: TimelineEntry {
  let date: Date
  let dlobState: DlobWState
}

struct HashPriceWidgetEntryView : View {
  var entry: Provider.Entry

//  @StateObject var dlobState = DlobWState.getDlobState()
//  @StateObject var dlobState = DlobWState()
  var bgColor: Color =  Color(.sRGB, red:0.580, green:0.695, blue:1.000)

  var body: some View {
    
    ZStack {
      bgColor
        .ignoresSafeArea()
      
      VStack {
        
        PriceWV(dlobState: entry.dlobState)

        Divider()

        (
          Text(entry.dlobState.dateStamp)
            .font(Font.system(.body, design: .monospaced).monospacedDigit())
            .foregroundColor(.blue)
          +
          Text(" ")
            .font(.body)
            .fontWeight(.bold)
          +
          Text(entry.dlobState.timeStamp)
            .font(Font.system(.body, design: .monospaced).monospacedDigit())
            .foregroundColor(.blue)
        )
          .font(.body)
          .fontWeight(.bold)
          .multilineTextAlignment(.leading)
          .lineLimit(1)
          .minimumScaleFactor(0.4)
          .padding([.leading, .trailing])
//        Text(entry.date, style: .time)
//          .font(.body)

      }
    }
  }
}

@main
struct HashPriceWidget: Widget {
  let kind: String = "HashPriceWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      HashPriceWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("HashPrice Widget")
    .description("Provenance Blockchain DLOB Exchange")
  }
}













//struct HashPriceWidget_Previews: PreviewProvider {
//  static var previews: some View {
//    HashPriceWidgetEntryView(entry: SimpleEntry(date: Date(), dlobState: Provider.dlobState!))
//      .previewContext(WidgetPreviewContext(family: .systemSmall))
//  }
//}
