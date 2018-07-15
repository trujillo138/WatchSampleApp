//
//  InterfaceController.swift
//  ExpensesWatchApp Extension
//
//  Created by Tomas Trujillo on 6/19/18.
//  Copyright © 2018 Tomas Trujillo. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
  
  @IBOutlet var numberOfBalancesLabel: WKInterfaceLabel!
  @IBOutlet var graphImage: WKInterfaceImage!
  
  private lazy var stateController: WatchStateController = {
    return WatchStateController.shared
  }()
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    createImage()
    // Configure interface objects here.
  }
  
  private func createImage() {
    let imageRect = CGRect(x: 0.0, y: 0.0, width: 70, height: 70)
    let lineWidth = imageRect.width * 0.15
    let radius = imageRect.midY - lineWidth
    UIGraphicsBeginImageContext(imageRect.size)
    let context = UIGraphicsGetCurrentContext()
    let path = UIBezierPath(arcCenter: CGPoint(x: imageRect.midX, y: imageRect.midY), radius: radius, startAngle: 0.0, endAngle: CGFloat.pi * 3 / 2, clockwise: true)
    context?.addPath(path.cgPath)
    context?.setLineWidth(lineWidth)
    context?.setLineCap(.round)
    context?.setStrokeColor(UIColor.green.cgColor)
    context?.setFillColor(UIColor.green.cgColor)
    context?.strokePath()
    context?.fillPath()
    let circleRadius = lineWidth
    let circlePath = UIBezierPath(ovalIn: CGRect(x: imageRect.midX - circleRadius, y: imageRect.midY + radius - circleRadius, width: circleRadius * 2, height: circleRadius * 2))
    circlePath.lineWidth = lineWidth * 0.1
    UIColor.black.setStroke()
    UIColor.white.setFill()
    circlePath.stroke()
    circlePath.fill()
    context?.addPath(circlePath.cgPath)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    graphImage.setImage(image!)
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
    refreshLabel()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  @IBAction private func pressedButton() {
    WatchAppWatchConnectivityHandler.shared.sendExpense(Expense(name: "Expense from watch", amount: 22, type: "Health", date: Date()))
  }
  
  @IBAction private func refreshLabel() {
    let number = WatchStateController.shared.balances.count
    numberOfBalancesLabel.setText("Balances: \(number)")
  }
  
  @IBAction private func createComplicationData() {
    stateController.adjustComplications()
  }
  
  
}
