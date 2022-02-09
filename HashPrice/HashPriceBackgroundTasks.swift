//
//  HashPriceBackgroundTasks.swift
//  HashPrice
//
//  Created by Frank Siebenlist on 1/16/22.
//

import SwiftUI
import BackgroundTasks
import Foundation

class HashPriceBackgroundTasks {
  
  // Add "Background Modes" capabilities in "Signing & Capabilities", and tick-off/enable the "Background fetch" and "Background processing"
  // MUST add following two to array of "Permitted background task scheduler identifiers" in Info.plist
  static let backgroundAppRefreshTaskSchedulerIdentifier = "com.creativeapptitude.HashPrice.backgroundfetch"
  static let backgroundProcessingTaskSchedulerIdentifier = "com.creativeapptitude.HashPrice.backgroundprocessing"
  
  static func registerBackgroundTasks(dlobState: DlobState) {
    print("registerBackgroundTasks - enter")
    
    BGTaskScheduler.shared.register(forTaskWithIdentifier: HashPriceBackgroundTasks.backgroundAppRefreshTaskSchedulerIdentifier, using: nil)
    { (task) in
      print("BackgroundAppRefreshTaskScheduler is executed NOW!")
      print("Background time remaining: \(UIApplication.shared.backgroundTimeRemaining)s")
      print(Date())
      HashPriceBackgroundTasks.scheduleAppRefresh(dlobState: dlobState)
      task.expirationHandler = {
        task.setTaskCompleted(success: false)
      }
      
      // Do some data fetching and call setTaskCompleted(success:) asap!
      Task() {
        // await dlobState.fetchDlobState()
        await dlobState.updateDlobState()
      }
      
      let isFetchingSuccess = true
      task.setTaskCompleted(success: isFetchingSuccess)
      print("BackgroundAppRefreshTaskScheduler is finished NOW!")
    }
    //HashPriceBackgroundTasks.scheduleAppRefresh()
    print("registerBackgroundTasks - exit")
  }
  
  static func scheduleAppRefresh(dlobState: DlobState) {
    print("scheduleAppRefresh - enter")
    
    let request = BGAppRefreshTaskRequest(identifier: HashPriceBackgroundTasks.backgroundAppRefreshTaskSchedulerIdentifier)
    
//    let refreshTimeMin: Double = Double(dlobState.notificationTimerMin)
    let refreshTimeMin: Double = 15
    request.earliestBeginDate = Date(timeIntervalSinceNow: refreshTimeMin * 60) // Refresh after refreshTimeMin minutes.
    
    do {
      try BGTaskScheduler.shared.submit(request)
      print("scheduleAppRefresh - exit")
      // set breakpoint here ^^^ and execute
      // "e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.creativeapptitude.HashPrice.backgroundfetch"]"
      // in debugger to force the background task to fire
    } catch {
      print("Could not schedule app refresh task \(error.localizedDescription)")
    }
  }
  
  static func registerNotifications() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
      if success {
        print("Notifications: Authorized.")
      } else if let error = error {
        print(error.localizedDescription)
      }
    }
  }
  
}
