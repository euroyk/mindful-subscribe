//
//  ReflectionService.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 23/11/2568 BE.
//

import Foundation

struct ReflectionService {
    
    /// Determines if a subscription needs a "Worth It?" check.
    /// Logic: 3 days before the next billing date.
    static func needsReflection(for subscription: Subscription) -> Bool {
        let calendar = Calendar.current
        
        // Calculate the date 3 days before billing
        guard let checkDate = calendar.date(byAdding: .day, value: -3, to: subscription.nextBillingDate) else {
            return false
        }
        
        // If today is exactly 3 days before billing (or within that window if we missed it)
        // And we haven't already logged a reflection for this cycle
        let isTimeToCheck = calendar.isDateInToday(checkDate)
        
        // Check if we already did a reflection for this billing cycle
        // We look for a log created within the last 25 days (rough approximation of a month cycle)
        let hasRecentLog = subscription.reflectionLogs.contains { log in
            guard let daysSinceLog = calendar.dateComponents([.day], from: log.date, to: Date()).day else { return false }
            return daysSinceLog < 25
        }
        
        return isTimeToCheck && !hasRecentLog
    }
    
    /// Calculates if a Nudge is needed based on low usage history.
    /// Returns a warning message if needed, or nil.
    static func getNudgeMessage(for subscription: Subscription) -> String? {
        // Get the last 3 logs, sorted by date descending
        let recentLogs = subscription.reflectionLogs
            .sorted { $0.date > $1.date }
            .prefix(3)
        
        // We need at least 2 logs to establish a pattern
        guard recentLogs.count >= 2 else { return nil }
        
        // Check if all recent logs are 'lowValue'
        let consistentlyLow = recentLogs.allSatisfy { $0.valueRating == .lowValue }
        
        if consistentlyLow {
            return "Seems like you haven't used this much lately. Pausing this could save you \(subscription.currency) \(Int(subscription.cost)) this month."
        }
        
        return nil
    }
}
