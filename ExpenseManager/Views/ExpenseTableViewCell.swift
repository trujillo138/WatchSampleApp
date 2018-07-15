//
//  ExpenseTableViewCell.swift
//  ExpenseManager
//
//  Created by Tomas Trujillo on 6/19/18.
//  Copyright © 2018 Tomas Trujillo. All rights reserved.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {

  //MARK: Outlets
  
  @IBOutlet private weak var expenseNameLabel: UILabel!
  @IBOutlet private weak var expenseAmountLabel: UILabel!
  @IBOutlet private weak var expenseTypeLabel: UILabel!
  @IBOutlet private weak var expenseDateLabel: UILabel!
  
  //MARK: Cell configuration
  
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
  }
  
  func configureCellWithModel(_ expense: Expense) {
    expenseNameLabel.text = expense.name
    expenseAmountLabel.text = "$ \(expense.amount)"
    expenseTypeLabel.text = expense.type
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    expenseDateLabel.text = dateFormatter.string(from: expense.date)
  }
  
}
