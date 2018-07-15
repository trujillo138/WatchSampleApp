//
//  AppWatchConnectivityHandler.swift
//  ExpenseManager
//
//  Created by Tomas Trujillo on 6/19/18.
//  Copyright © 2018 Tomas Trujillo. All rights reserved.
//

import Foundation
import WatchConnectivity

class AppWatchConnectivityHandler: NSObject, WCSessionDelegate {

  private let watchConnectivityHandler = WatchConnectivityHandler()
  private var session: WCSession {
    return WCSession.default
  }
  var stateController: StateController?
  
  func startWatchSession() {
    if WCSession.isSupported() {
      session.delegate = self
      session.activate()
      NotificationCenter.default.addObserver(self, selector: #selector(updateAppleWatchContext), name: Notifier.ExpenseAddedThroughApp, object: nil)
    }
  }
  
  @objc private func updateAppleWatchContext() {
    guard WCSession.isSupported() && session.isPaired && session.isWatchAppInstalled, let balance = stateController?.getExpensesBalance() else { return }
    do {
      try session.updateApplicationContext(watchConnectivityHandler.getSendableFormatFromExpensesBalance(balance))
    } catch {
      print("Error updating context \(error)")
    }
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
    if watchConnectivityHandler.messageRequestExpensesInfo(message) {
      print("Requesting expense data")
      replyHandler(["response": "sending data"])
    } else if let expense = watchConnectivityHandler.readExpenseFromWatchMessage(message) {
      stateController?.addExpense(expense)
      NotificationCenter.default.post(name: Notifier.ExpenseAddedThroughAppleWatch, object: nil)
      guard let balance = stateController?.getExpensesBalance() else { return replyHandler(["response": "expense added"]) }
      replyHandler(watchConnectivityHandler.getSendableFormatFromExpensesBalance(balance))
    }
    replyHandler(["response": "unrecognized request"])
  }
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
  }
  
  func sessionDidBecomeInactive(_ session: WCSession) {
    
  }
  
  func sessionDidDeactivate(_ session: WCSession) {
    
  }
  
}
