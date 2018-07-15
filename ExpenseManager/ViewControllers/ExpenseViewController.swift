//
//  ExpenseViewController.swift
//  ExpenseManager
//
//  Created by Tomas Trujillo on 6/19/18.
//  Copyright © 2018 Tomas Trujillo. All rights reserved.
//

import UIKit

class ExpenseViewController: UIViewController {

  //MARK: Outlets
  
  @IBOutlet private weak var expenseNameTextField: UITextField!
  @IBOutlet private weak var expenseAmountTextField: UITextField!
  @IBOutlet private weak var expenseTypePickerView: UIPickerView!
  @IBOutlet private weak var expenseDatePicker: UIDatePicker!
  
  //MARK: Properties
  
  var stateController: StateController?
  var types: [String] {
    return stateController?.types ?? []
  }

  //MARK: ViewController Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configurePickerView()
  }
  
  private func configurePickerView() {
    expenseTypePickerView.delegate = self
    expenseTypePickerView.dataSource = self
  }
  
  //MARK: Actions
  
  @IBAction private func cancelTapped() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction private func doneTapped() {
    let name = expenseNameTextField.text ?? ""
    let amount = Int(expenseAmountTextField.text ?? "") ?? 0
    let date = expenseDatePicker.date
    let type = types[expenseTypePickerView.selectedRow(inComponent: 0)]
    stateController?.addExpenseWith(name: name, amount: amount, type: type, date: date)
    dismiss(animated: true, completion: nil)
  }

}

extension ExpenseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return types[row]
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return types.count
  }
  
}
