//
//  Notifier.swift
//  ExpenseManager
//
//  Created by Tomas Trujillo on 6/19/18.
//  Copyright © 2018 Tomas Trujillo. All rights reserved.
//

import Foundation

class Notifier {
  
  static let ExpenseAddedThroughAppleWatch = Notification.Name(rawValue: "com.ttapps.expensesManager.addedExpenseInAppleWatch")
  static let ExpenseAddedThroughApp = Notification.Name(rawValue: "com.ttapps.expensesManager.addedExpenseInApp")
  
}
