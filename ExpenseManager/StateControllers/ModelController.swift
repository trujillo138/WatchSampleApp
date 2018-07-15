//
//  ModelController.swift
//  ExpenseManager
//
//  Created by Tomas Trujillo on 6/19/18.
//  Copyright © 2018 Tomas Trujillo. All rights reserved.
//

import Foundation

class ModelController {
  
  private var docPath: String {
    guard var userURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return "" }
    userURL.appendPathComponent("expenses")
    return userURL.path
  }
  
  var expenses: [Expense]!
  
  func addExpense(_ expense: Expense) {
    expenses?.append(expense)
    save()
  }
  
  func save() {
    DispatchQueue(label: "SavingQueue").async { [weak self] in
      guard let `self` = self else { return }
      NSKeyedArchiver.archiveRootObject(self.expenses, toFile: self.docPath)
    }
  }
  
  func load() {
    DispatchQueue(label: "Loadingqueue").async {
      guard let loadedExpenses = NSKeyedUnarchiver.unarchiveObject(withFile: self.docPath) as? [Expense] else {
        self.expenses = []
        return
      }
      self.expenses = loadedExpenses
    }
  }
 
  func adjustExpenses() {
    var date = Date()
    for expense in expenses {
      expense.date = date
      date = date.addingTimeInterval(-3600)
    }
  }
  
}
