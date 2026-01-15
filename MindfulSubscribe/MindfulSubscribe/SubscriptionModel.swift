//
//  SubscriptionModel.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 20/11/2568 BE.
//

import Foundation
import SwiftData
import SwiftUI

// MARK: - Enums

enum Category: String, CaseIterable, Codable {
    case entertainment = "Entertainment"
    case utility = "Utility"
    case work = "Work"
    case healthandfitness = "Health & Fitness"
    case other = "Other"
}

enum BillingCycle: String, CaseIterable, Codable {
    case monthly = "Monthly"
    case yearly = "Yearly"
    case weekly = "Weekly"
}

enum ValueRating: String, Codable {
    case highValue = "High Value"     // "Used daily, love it!"
    case mediumValue = "Medium Value" // "Used it sometimes"
    case lowValue = "Low Value"       // "Barely opened it"
}

// MARK: - SwiftData Models

@Model
class Subscription {
    var id: UUID
    var name: String
    var iconName: String
    var cost: Double
    var currency: String
    var billingCycle: BillingCycle
    var nextBillingDate: Date
    var category: Category
    var notificationsEnabled: Bool
    var isPaid: Bool
    
    // Relationship to logs
    @Relationship(deleteRule: .cascade) var reflectionLogs: [ReflectionLog] = []
    
    init(name: String, iconName: String = "sparkles", cost: Double, currency: String = "THB", billingCycle: BillingCycle = .monthly, nextBillingDate: Date, category: Category = .other, notificationsEnabled: Bool = true) {
        self.id = UUID()
        self.name = name
        self.iconName = iconName
        self.cost = cost
        self.currency = currency
        self.billingCycle = billingCycle
        self.nextBillingDate = nextBillingDate
        self.category = category
        self.notificationsEnabled = notificationsEnabled
        self.isPaid = false
    }
    
    // Helper for UI logic
    var dueWarningText: String? {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: Date(), to: nextBillingDate).day ?? 0
        
        if days >= 0 && days <= 7 {
            if days == 0 { return "Due today" }
            return "Due in \(days) days"
        }
        return nil
    }
    
    // *** NEW LOGIC ADDED HERE ***
    /// Advances the billing date to the next cycle and resets payment status
    func advanceBillingDate() {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        
        switch billingCycle {
        case .monthly:
            dateComponent.month = 1
        case .yearly:
            dateComponent.year = 1
        case .weekly:
            dateComponent.day = 7
        }
        
        // Calculate the new date
        if let newDate = calendar.date(byAdding: dateComponent, to: nextBillingDate) {
            self.nextBillingDate = newDate
            // Reset paid status for the new cycle
            self.isPaid = false
        }
    }
}

@Model
class ReflectionLog {
    var date: Date
    var valueRating: ValueRating
    var note: String?
    
    // Relationship back to Subscription
    var subscription: Subscription?
    
    init(date: Date = Date(), valueRating: ValueRating, note: String? = nil) {
        self.date = date
        self.valueRating = valueRating
        self.note = note
    }
}
