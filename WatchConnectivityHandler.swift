//
//  WatchConnectivityHandler.swift
//  ExpenseManager
//
//  Created by Tomas Trujillo on 6/19/18.
//  Copyright © 2018 Tomas Trujillo. All rights reserved.
//

import Foundation

class WatchConnectivityHandler {
  
  private static let RequestDataKey = "com.ttapps.requestExpenses"
  
  private struct ExpenseWatchKeys {
    static let ExpenseNameWatchKey = "com.ttapps.expenseManager.expenseName"
    static let ExpenseAmountWatchKey = "com.ttapps.expenseManager.expenseAmount"
    static let ExpenseTypeWatchKey = "com.ttapps.expenseManager.expenseType"
    static let ExpenseDateWatchKey = "com.ttapps.expenseManager.expenseDate"
    static let ExpenseBalanceLastExpenseKey = "com.ttapps.expenseManager.lastExpense"
    static let ExpenseBalanceAmountSavedKey = "com.ttapps.expenseManager.amountSaved"
    static let ExpenseBalanceAmountSpentKey = "com.ttapps.expenseManager.amountSpent"
    static let ExpenseBalanceDateOfBalanceKey = "com.ttapps.expenseManager.dateOfBalance"
  }
  
  func getSendableFormatFromExpense(_ expense: Expense) -> [String: Any] {
    return [ExpenseWatchKeys.ExpenseNameWatchKey: expense.name,
            ExpenseWatchKeys.ExpenseAmountWatchKey: expense.amount,
            ExpenseWatchKeys.ExpenseTypeWatchKey: expense.type,
            ExpenseWatchKeys.ExpenseDateWatchKey: expense.date]
  }
  
  func readExpenseFromWatchMessage(_ message: [String: Any]) -> Expense? {
    guard let name = message[ExpenseWatchKeys.ExpenseNameWatchKey] as? String,
      let amount = message[ExpenseWatchKeys.ExpenseAmountWatchKey] as? Int,
      let type = message[ExpenseWatchKeys.ExpenseTypeWatchKey] as? String,
      let date = message[ExpenseWatchKeys.ExpenseDateWatchKey] as? Date else {
        return nil
    }
    return Expense(name: name, amount: amount, type: type, date: date)
  }
  
  func getSendableFormatFromExpensesBalance(_ balance: ExpensesBalance) -> [String: Any] {
    return [ExpenseWatchKeys.ExpenseBalanceLastExpenseKey: getSendableFormatFromExpense(balance.lastExpense),
            ExpenseWatchKeys.ExpenseBalanceAmountSavedKey: balance.amountSaved,
            ExpenseWatchKeys.ExpenseBalanceAmountSpentKey: balance.amountSpent,
            ExpenseWatchKeys.ExpenseBalanceDateOfBalanceKey: balance.dateOfBalance]
  }
  
  func readExpenseBalanceFromRequest(_ message: [String: Any]) -> ExpensesBalance? {
    guard let expenseData = message[ExpenseWatchKeys.ExpenseBalanceLastExpenseKey] as? [String: Any],
      let expense = readExpenseFromWatchMessage(expenseData),
      let amountSaved = message[ExpenseWatchKeys.ExpenseBalanceAmountSavedKey] as? Int,
      let amountSpent = message[ExpenseWatchKeys.ExpenseBalanceAmountSpentKey] as? Int,
      let dateOfBalance = message[ExpenseWatchKeys.ExpenseBalanceDateOfBalanceKey] as? Date else {
        return nil
    }
    return ExpensesBalance(lastExpense: expense, amountSaved: amountSaved, amountSpent: amountSpent, dateOfBalance: dateOfBalance)
  }
  
  func messageRequestExpensesInfo(_ message: [String: Any]) -> Bool {
    guard let _ = message[WatchConnectivityHandler.RequestDataKey] else { return false}
    return true
  }
  
}
