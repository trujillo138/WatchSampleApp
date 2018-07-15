//
//  File.swift
//  ExpensesWatchApp Extension
//
//  Created by Tomas Trujillo on 6/21/18.
//  Copyright © 2018 Tomas Trujillo. All rights reserved.
//

import Foundation

class WatchModelController {
  
  private var docLoaction: String {
    guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return "" }
    return path.appendingPathComponent("expensesBalances").path
  }
  
  var balances: [ExpensesBalance] = []
  
  func saveBalance(_ balance: ExpensesBalance) {
    if let lastBalance = balances.last {
      let dateOfLastBalance = lastBalance.dateOfBalance
      let hours = balance.dateOfBalance.timeIntervalSince(dateOfLastBalance) / 3600
      if (hours > 1) {
        balances.append(balance)
      } else {
        lastBalance.amountSaved = balance.amountSaved
        lastBalance.amountSpent = balance.amountSpent
        lastBalance.lastExpense = balance.lastExpense
      }
    } else {
      balances.append(balance)
    }
    save()
  }
  
  func save() {
    DispatchQueue(label: "SavingQueue").async { [weak self] in
      guard let strongSelf = self else { return }
      NSKeyedArchiver.archiveRootObject(strongSelf.balances, toFile: strongSelf.docLoaction)
    }
  }
  
  func load() {
    DispatchQueue(label: "LoadingQueue").async { [weak self] in
      guard let strongSelf = self else { return }
      guard let balances = NSKeyedUnarchiver.unarchiveObject(withFile: strongSelf.docLoaction) as? [ExpensesBalance] else { return }
      strongSelf.balances = balances
    }
  }
  
  func adjustComplications() {
    var date = Date()
    var newBalances: [ExpensesBalance] = []
    for _ in 0 ..< 10 {
      let balance = ExpensesBalance(lastExpense: Expense(name: "Fake expense", amount: 10, type: "Food", date: date),
                                    amountSaved: Int(arc4random_uniform(100)), amountSpent: Int(arc4random_uniform(100)), dateOfBalance: date)
      date = date.addingTimeInterval(-3600)
      newBalances.append(balance)
    }
    self.balances = newBalances
    save()
  }
  
  init() {
    load()
  }
  
}
