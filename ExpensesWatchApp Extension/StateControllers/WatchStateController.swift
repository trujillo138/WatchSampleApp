//
//  WatchStateController.swift
//  ExpensesWatchApp Extension
//
//  Created by Tomas Trujillo on 6/21/18.
//  Copyright © 2018 Tomas Trujillo. All rights reserved.
//

import Foundation

class WatchStateController {
  
  static let shared = WatchStateController()
  
  private let modelController = WatchModelController()
  
  var balances: [ExpensesBalance] {
    return modelController.balances
  }
  
  func saveNewBalance(_ balance: ExpensesBalance) {
    modelController.saveBalance(balance)
  }
  
  func adjustComplications() {
    modelController.adjustComplications()
  }
  
  private init() {
    
  }
  
}
