//
//  HashPriceMV.swift
//  HashPrice
//
//  Created by Frank Siebenlist on 1/13/22.
//

import SwiftUI
import Foundation
import UserNotifications
import WidgetKit
#if !os(macOS)
import UIKit
#endif

@MainActor class DlobState: ObservableObject {
  
  @Published var xrate: String = "0.666"
  @Published var hxrate: String = "1.000"
  @Published var lxrate: String = "0.111"
  @Published var hashVolume: String = "1,111,111"
  @Published var usdVolume: String = "222,222"
  
  @Published var dateStamp: String = "00/00/0000"
  @Published var timeStamp: String = "00:00:00"
  
  @Published var hashAssets: Int = 1234567
  @Published var fakeRandomPrice: Bool = false
  @Published var notificationTimerMin: Float = 15
  
  @Published var appVersion: String = "???"

  //
  
  static var theDlobState: DlobState? = nil
  var previousPricePerUnit_usd_hash_badge: Int = 0
  var previous_xrate = ""
  
  //
  
  static func getDlobState() -> DlobState {
    if theDlobState == nil { theDlobState = DlobState()}
    return theDlobState!
  }
  
  // methods
  
  
  func updateDlobState() async {
    print("updateDlobState - enter")
    
    if let appVersion1 = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
      self.appVersion = appVersion1
      print("App version: \(appVersion1)")
    } else {
       print("your platform does not support this feature.")
    }

    var decodedResponse1: [OrderBooksResponse]? = nil
    
    if !self.fakeRandomPrice {
      
      decodedResponse1 = await OrderBooksResponse.fetchDlobState()
      
      guard decodedResponse1 != nil else {
        print("updateDlobState - decodedResponse1 == nil")
        return
      }
      
    } else {
      
      decodedResponse1 = [OrderBooksResponse.fetchFakeDlobState()]
      
    }
    
    // let decodedResponse: OrderBooksResponse! = decodedResponse1![0]
    
    print("updateDlobState - fakeRandomPrice:", fakeRandomPrice)
    
    var hasHashUsdTicker : Bool = false
    let decodedResponse2 : [OrderBooksResponse]! = decodedResponse1
    
    for decodedResponse in decodedResponse2 {
      
      if decodedResponse.ticker_id == "HASH_USD" {
        hasHashUsdTicker = true
        
        let latestPricePerUnit_usd_hash = decodedResponse.last_price
        let lowPricePerUnit_usd_hash = decodedResponse.low
        let highPricePerUnit_usd_hash = decodedResponse.high
        let volumeTraded_hash = decodedResponse.target_volume
        let volumeTraded_usd = decodedResponse.base_volume
        self.xrate = String(format: "%.3f", latestPricePerUnit_usd_hash)
        self.hxrate = String(format: "%.3f", highPricePerUnit_usd_hash)
        self.lxrate = String(format: "%.3f", lowPricePerUnit_usd_hash)
        self.hashVolume = Int64(volumeTraded_hash).withCommas()
        self.usdVolume = Int64(volumeTraded_usd).withCommas()
        
        print("updateDlobState - false! - self.xrate:", self.xrate)
        
        let timeFormatter = DateFormatter()
        let dateFormatter = DateFormatter()
        let now = Date()
        //HH:mm:ss MM/dd/yyyy
        dateFormatter.dateFormat = "MM/dd/yyyy"
        timeFormatter.dateFormat = "HH:mm:ss"
        self.dateStamp = dateFormatter.string(from: now)
        self.timeStamp = timeFormatter.string(from: now)
        
        let latestPricePerUnit_usd_hash_badge = Int((latestPricePerUnit_usd_hash * 1000).rounded())
        if previousPricePerUnit_usd_hash_badge != latestPricePerUnit_usd_hash_badge {
          previousPricePerUnit_usd_hash_badge = latestPricePerUnit_usd_hash_badge
          DispatchQueue.main.async {
            //          UNUserNotificationCenter.current().requestAuthorization(options: .badge) { (granted, error) in
            //            if (error == nil && granted) {
            print("UIApplication.shared.applicationIconBadgeNumber", latestPricePerUnit_usd_hash_badge)
            UIApplication.shared.applicationIconBadgeNumber = latestPricePerUnit_usd_hash_badge
            //        }
            //      }
          } //DispatchQueue
        } // if previousPricePerUnit...
        
        if self.xrate != previous_xrate {
          previous_xrate = self.xrate
          // Push Local Notifications
          let hashNotificationRequestId = "hashNotificationRequestId"
          let content = UNMutableNotificationContent()
          //      content.title =    "HASH_USD: $" + self.xrate
          content.title =    self.xrate + " $/Hash"
          content.subtitle = "H/L: " + self.hxrate + " / " + self.lxrate
          //      content.subtitle = "H/L/V: " + self.hxrate + " / " + self.lxrate + " / " + self.usdVolume
          //content.sound = UNNotificationSound.default
          // show this notification one seconds from now
          let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
          // choose a random identifier
          let request = UNNotificationRequest(identifier: hashNotificationRequestId, content: content, trigger: trigger)
          // add our notification request
          Task() {
            do {
              try await UNUserNotificationCenter.current().add(request)
              print("added notification: ", content.title)}
            catch {
              print("UNUserNotificationCenter.current().add(request): exception!!!")
            } //do
          } //Task
        } // if self.xrate
        
        break // dealt with the one and only HashUsdTicker - get out of for loop
        
      } // if decodedResponse...
    } // for decodedResponse...
    
    if !hasHashUsdTicker {
      print("updateDlobState - ERROR - No HASH_USD ticker_id in OrderBooksResponse array")
      return  // nothing to update
    }
    
  } // func updateDlobState
} // class DlobState
