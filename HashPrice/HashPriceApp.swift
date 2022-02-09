//
//  HashPriceApp.swift
//  HashPrice
//
//  Created by Frank Siebenlist on 1/13/22.
//

import SwiftUI
import BackgroundTasks

@main
struct HashPriceApp: App {
  
  @Environment(\.scenePhase) private var scenePhase
  
  @StateObject var dlobState = DlobState.getDlobState()
  
  init() {
    HashPriceBackgroundTasks.registerBackgroundTasks(dlobState: dlobState)
    HashPriceBackgroundTasks.registerNotifications()
  }
  
  var body: some Scene {
    WindowGroup {
      HashPriceView(dlobState: dlobState)
        .onChange(of: scenePhase) { (newScenePhase) in
          switch newScenePhase {
          case .active:
            print("scene is now active!")
            DispatchQueue.main.async {
              Task {
                // await dlobState.fetchDlobState()
                await dlobState.updateDlobState()
              }
            }
          case .inactive:
            print("scene is now inactive!")
          case .background:
            print("scene is now in the background!")
            HashPriceBackgroundTasks.scheduleAppRefresh(dlobState: dlobState)
          @unknown default:
            print("Apple must have added something new!")
          }
        }
    }
  }
}
