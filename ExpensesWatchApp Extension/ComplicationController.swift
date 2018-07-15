//
//  ComplicationController.swift
//  ExpensesWatchApp Extension
//
//  Created by Tomas Trujillo on 6/19/18.
//  Copyright © 2018 Tomas Trujillo. All rights reserved.
//

import ClockKit
import CoreGraphics


class ComplicationController: NSObject, CLKComplicationDataSource {
  
  private lazy var stateController: WatchStateController = {
    return WatchStateController.shared
  }()
  
  // MARK: - Timeline Configuration
  
  func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
    handler([.backward])
  }
  
  func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
    guard let firstBalance = stateController.balances.last else {
      handler(nil)
      return
    }
    handler(firstBalance.dateOfBalance)
  }
  
  func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
    handler(Date())
  }
  
  func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
    handler(.hideOnLockScreen)
  }
  
  // MARK: - Timeline Population
  
  func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
    // Call the handler with the current timeline entry
    if complication.family == .utilitarianLarge {
      guard let currentBalance = stateController.balances.first else {
        handler(nil)
        return
      }
      let largeTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
      largeTemplate.textProvider = CLKSimpleTextProvider(text:  "👍$\(currentBalance.amountSaved) 👎$\(currentBalance.amountSpent)")
      let timeLineEntry = CLKComplicationTimelineEntry(date: currentBalance.dateOfBalance, complicationTemplate: largeTemplate)
      handler(timeLineEntry)
    } else {
      handler(nil)
    }
  }
  
  func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
    if complication.family == .utilitarianLarge {
      var entries: [CLKComplicationTimelineEntry] = []
      let filteredBalances = stateController.balances.filter { return $0.dateOfBalance < date }
      for i in max(0, filteredBalances.count - limit) ..< filteredBalances.count {
        let balance = filteredBalances[i]
        let largeTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
        largeTemplate.textProvider = CLKSimpleTextProvider(text:  "👍$\(balance.amountSaved) 👎$\(balance.amountSpent)")
        let timeLineEntry = CLKComplicationTimelineEntry(date: balance.dateOfBalance, complicationTemplate: largeTemplate)
        entries.append(timeLineEntry)
      }
      handler(entries)
    } else {
      handler(nil)
    }
  }
  
  // MARK: - Placeholder Templates
  
  func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
    // This method will be called once per supported complication, and the results will be cached
    var template: CLKComplicationTemplate?
    switch complication.family {
    case .circularSmall:
      let circularTemplate = CLKComplicationTemplateCircularSmallSimpleImage()
      guard let image = UIImage(named: "Food") else { break }
      circularTemplate.imageProvider = CLKImageProvider(onePieceImage:image)
      template = circularTemplate
    case .utilitarianLarge:
      let largeTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
      largeTemplate.textProvider = CLKSimpleTextProvider(text: "👍$90 👎$10")
      template = largeTemplate
    default:
      print("do nothing")
    }
    handler(template)
  }
  
}
