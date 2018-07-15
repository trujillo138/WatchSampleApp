//
//  WatchAppWatchConnectivityHandler.swift
//  ExpensesWatchApp Extension
//
//  Created by Tomas Trujillo on 6/19/18.
//  Copyright © 2018 Tomas Trujillo. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchAppWatchConnectivityHandler: NSObject, WCSessionDelegate {
  
  static let shared: WatchAppWatchConnectivityHandler = WatchAppWatchConnectivityHandler()
  
  private let watchConnectivityHandler = WatchConnectivityHandler()
  
  private lazy var stateController: WatchStateController = {
    return WatchStateController.shared
  }()
  
  private override init() {
    super.init()
  }
  
  static func startWatchSession() {
    shared.startWatchSession()
  }
  
  func startWatchSession() {
    if WCSession.isSupported() {
      let session = WCSession.default
      session.delegate = self
      session.activate()
    }
  }
  
  func sendExpense(_ expense: Expense) {
    guard WCSession.isSupported() else { return }
    let data = watchConnectivityHandler.getSendableFormatFromExpense(expense)
    WCSession.default.sendMessage(data, replyHandler: { [weak self] response in
      print(response)
      guard let strongSelf = self, let balance = strongSelf.watchConnectivityHandler.readExpenseBalanceFromRequest(response) else { return }
      strongSelf.stateController.saveNewBalance(balance)
    }, errorHandler: { error in
      print(error)
      })
    WCSession.default.sendMessage(data, replyHandler: nil, errorHandler: nil)
  }
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
  }
  
  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    guard let balance = watchConnectivityHandler.readExpenseBalanceFromRequest(applicationContext) else { return }
    stateController.saveNewBalance(balance)
  }
  
}
