//
//  StateController.swift
//  ExpenseManager
//
//  Created by Tomas Trujillo on 6/19/18.
//  Copyright © 2018 Tomas Trujillo. All rights reserved.
//

import Foundation

class StateController {
  
  var expenses: [Expense] {
    return modelController.expenses
  }
  var modelController: ModelController!
  
  var types: [String] {
    return ["Food", "Health", "Banking", "Education"]
  }
  
  init() {
    modelController = ModelController()
    modelController.load()
  }
  
  func addExpense(_ expense: Expense) {
    modelController.addExpense(expense)
  }
  
  func addExpenseWith(name: String, amount: Int, type: String, date: Date) {
    let newExpense = Expense(name: name, amount: amount, type: type, date: date)
    modelController.addExpense(newExpense)
    NotificationCenter.default.post(name: Notifier.ExpenseAddedThroughApp, object: nil)
  }
  
  func getExpensesBalance() -> ExpensesBalance? {
    return ExpensesBalance.createBalanceFromExpenses(expenses)
  }
  
  func adjustExpenses() {
    modelController.adjustExpenses()
    NotificationCenter.default.post(name: Notifier.ExpenseAddedThroughApp, object: nil)
  }
  
}
