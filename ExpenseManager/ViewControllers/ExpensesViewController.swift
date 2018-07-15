//
//  ExpensesViewController.swift
//  ExpenseManager
//
//  Created by Tomas Trujillo on 6/19/18.
//  Copyright © 2018 Tomas Trujillo. All rights reserved.
//

import UIKit

class ExpensesViewController: UIViewController {
  
  //MARK: Outlets
  
  @IBOutlet private weak var expensesTableView: UITableView!
  
  //MARK: Properties
  
  var stateController: StateController?
  private var expenses: [Expense] {
    return stateController?.expenses ?? []
  }
  private static let ExpenseCellIdentifier = "ExpenseCellIdentifier"
  private static let ShowAddExpenseViewControllerSegueIdentifier = "ShowAddExpenseView"
  
  //MARK: ViewController Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    NotificationCenter.default.addObserver(self, selector: #selector(dataSourceWasUpdated), name: Notifier.ExpenseAddedThroughAppleWatch, object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    expensesTableView.reloadData()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  private func configureTableView() {
    expensesTableView.delegate = self
    expensesTableView.dataSource = self
    let tableCellNib = UINib(nibName: "ExpenseTableViewCell", bundle: nil)
    expensesTableView.register(tableCellNib, forCellReuseIdentifier: ExpensesViewController.ExpenseCellIdentifier)
    expensesTableView.reloadData()
  }
  
  @objc private func dataSourceWasUpdated() {
    DispatchQueue.main.async {
      self.expensesTableView.reloadData()
    }
  }
  
  @IBAction private func addExpenseTapped() {
    performSegue(withIdentifier: ExpensesViewController.ShowAddExpenseViewControllerSegueIdentifier, sender: self)
  }
  
  @IBAction private func updateExpensesDate(_ sender: Any) {
    stateController?.adjustExpenses()
    expensesTableView.reloadData()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == ExpensesViewController.ShowAddExpenseViewControllerSegueIdentifier {
      guard let dvc = segue.destination as? ExpenseViewController else { return }
      dvc.stateController = stateController
    }
  }

}
extension ExpensesViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return expenses.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpensesViewController.ExpenseCellIdentifier) as? ExpenseTableViewCell else { return UITableViewCell() }
    let expense = self.expenses[indexPath.row]
    cell.configureCellWithModel(expense)
    return cell
  }
  
}
