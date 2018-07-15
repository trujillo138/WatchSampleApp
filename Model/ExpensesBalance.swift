//
//  ExpensesBalance.swift
//  ExpenseManager
//
//  Created by Tomas Trujillo on 6/21/18.
//  Copyright © 2018 Tomas Trujillo. All rights reserved.
//

import Foundation

class ExpensesBalance: NSObject, NSCoding {
  
  //MARK: Keys
  
  private struct Keys {
    static let LastExpenseKey = "LastExpense"
    static let AmountSavedKey = "AmountSaved"
    static let AmountSpentKey = "AmountSpent"
    static let DateOfBalanceKey = "DateOfBalance"
  }
  
  //MARK: Properties
  
  var lastExpense: Expense
  var amountSaved: Int
  var amountSpent: Int
  var dateOfBalance: Date
  private static let TotalSavings = 1000000
  
  //MARK: Initializers
  
  init(lastExpense: Expense, amountSaved: Int, amountSpent: Int, dateOfBalance: Date) {
    self.lastExpense = lastExpense
    self.amountSaved = amountSaved
    self.amountSpent = amountSpent
    self.dateOfBalance = dateOfBalance
  }
  
  //MARK: Coding
  
  required init?(coder aDecoder: NSCoder) {
    self.lastExpense = aDecoder.decodeObject(forKey: Keys.LastExpenseKey) as! Expense
    self.amountSaved = aDecoder.decodeInteger(forKey: Keys.AmountSavedKey)
    self.amountSpent = aDecoder.decodeInteger(forKey: Keys.AmountSpentKey)
    self.dateOfBalance = aDecoder.decodeObject(forKey: Keys.DateOfBalanceKey) as? Date ?? Date()
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(lastExpense, forKey: Keys.LastExpenseKey)
    aCoder.encode(amountSaved, forKey: Keys.AmountSavedKey)
    aCoder.encode(amountSpent, forKey: Keys.AmountSpentKey)
    aCoder.encode(dateOfBalance, forKey: Keys.DateOfBalanceKey)
  }
  
  //MARK: Helper methods
  
  static func createBalanceFromExpenses(_ expenses: [Expense]) -> ExpensesBalance? {
    guard let lastExpenseOfPeriod = expenses.last else { return  nil }
    let currentDate = Date()
    let totalAmountSpent = expenses.reduce(0, { x, e in
      x + e.amount
    })
    let totalAmountSaved = TotalSavings - totalAmountSpent
    return ExpensesBalance(lastExpense: lastExpenseOfPeriod, amountSaved: totalAmountSaved, amountSpent: totalAmountSpent, dateOfBalance: currentDate)
  }
  
}
