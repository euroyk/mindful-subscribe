//
//  CalendarGridView.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 21/11/2568 BE.
//

import SwiftUI

struct CalendarGridView: View {
    @Binding var currentMonth: Date
    @Binding var selectedDate: Date
    let subscriptions: [Subscription]
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack {
            // Weekday Headers
            HStack {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(Theme.bodyFont(size: 12, weight: .bold))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 8)
            
            // Days Grid
            LazyVGrid(columns: columns, spacing: 15) {
                // Spacers for empty days at start of month
                ForEach(0..<currentMonth.startOfMonthOffset(), id: \.self) { _ in
                    Text("")
                }
                
                // Actual Days
                ForEach(currentMonth.getAllDaysInMonth(), id: \.self) { date in
                    DayCellView(
                        date: date,
                        isSelected: date.isSameDay(as: selectedDate),
                        hasDue: hasDue(on: date)
                    )
                    .onTapGesture {
                        selectedDate = date
                    }
                }
            }
        }
        .padding()
        .background(Theme.itemBox)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func hasDue(on date: Date) -> Bool {
        // Updated to use nextBillingDate
        return subscriptions.contains { $0.nextBillingDate.isSameDay(as: date) }
    }
}
