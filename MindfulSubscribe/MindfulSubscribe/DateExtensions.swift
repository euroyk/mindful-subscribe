//
//  DateExtensions.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 21/11/2568 BE.
//

import Foundation

extension Date {
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
    
    func getAllDaysInMonth() -> [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)!
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
        return range.compactMap { day -> Date? in
            return calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)
        }
    }
    
    func startOfMonthOffset() -> Int {
        let calendar = Calendar.current
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
        return calendar.component(.weekday, from: firstDayOfMonth) - 1
    }
    
    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    func isPast() -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let checkDate = calendar.startOfDay(for: self)
        return checkDate < today
    }
    
    func isFuture() -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let checkDate = calendar.startOfDay(for: self)
        return checkDate > today
    }
    
    func formatMonthYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self)
    }
    
    // New Helper
    func changeMonth(by value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: value, to: self) ?? self
    }
}
