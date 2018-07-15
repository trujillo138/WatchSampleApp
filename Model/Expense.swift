//
//  Expense.swift
//  ExpenseManager
//
//  Created by Tomas Trujillo on 6/19/18.
//  Copyright © 2018 Tomas Trujillo. All rights reserved.
//

import Foundation

class Expense: NSObject, NSCoding {
  
  private struct Keys {
    static let NameKey = "Name"
    static let AmountKey = "Amount"
    static let TypeKey = "Type"
    static let DateKey = "Date"
  }
  
  //MARK: Properties
  
  var name: String
  
  var amount: Int
  
  var type: String
  
  var date: Date
  
  init(name: String, amount: Int, type: String, date: Date) {
    self.name = name
    self.amount = amount
    self.type = type
    self.date = date
  }
  
  required init?(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObject(forKey: Keys.NameKey) as? String ?? ""
    amount = aDecoder.decodeInteger(forKey: Keys.AmountKey)
    type = aDecoder.decodeObject(forKey: Keys.TypeKey) as? String ?? ""
    date = aDecoder.decodeObject(forKey: Keys.DateKey) as? Date ?? Date()
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: Keys.NameKey)
    aCoder.encode(amount, forKey: Keys.AmountKey)
    aCoder.encode(type, forKey: Keys.TypeKey)
    aCoder.encode(date, forKey: Keys.DateKey)
  }
  
}
