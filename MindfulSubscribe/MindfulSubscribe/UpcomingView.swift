//
//  UpcomingView.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 21/11/2568 BE.
//

import SwiftUI
import SwiftData

struct UpcomingView: View {
    @Query private var subscriptions: [Subscription]
    @State private var currentMonth = Date()
    @State private var selectedDate = Date()
    
    // Filter subscriptions for the selected date
    var selectedDateSubscriptions: [Subscription] {
        subscriptions.filter { $0.nextBillingDate.isSameDay(as: selectedDate) }
    }
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // 1. Header Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Upcoming")
                            .font(Theme.headingFont(size: 32))
                            .foregroundColor(Theme.headingText)
                        
                        Text("Don't let these bills sneak up on you!")
                            .font(Theme.bodyFont(size: 16))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // 2. Calendar Header
                    CalendarHeaderView(currentMonth: $currentMonth)
                    
                    // 3. Calendar Grid Box
                    CalendarGridView(
                        currentMonth: $currentMonth,
                        selectedDate: $selectedDate,
                        subscriptions: subscriptions
                    )
                    .padding(.horizontal)
                    
                    // 4. Selected Date List Box
                    VStack(alignment: .leading, spacing: 16) {
                        Text(selectedDateHeader())
                            .font(Theme.headingFont(size: 18))
                            .foregroundColor(Theme.headingText)
                        
                        if selectedDateSubscriptions.isEmpty {
                            Text("No payments due on this day.")
                                .font(Theme.bodyFont(size: 14))
                                .foregroundColor(.gray)
                                .padding(.vertical, 10)
                        } else {
                            ForEach(selectedDateSubscriptions) { sub in
                                SubscriptionRowView(sub: sub, onCheck: {
                                    togglePaid(sub)
                                })
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Theme.itemBox)
                    .cornerRadius(Theme.cornerRadius)
                    .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 100) // Spacing for TabBar
                }
            }
        }
    }
    
    private func selectedDateHeader() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMM"
        if selectedDate.isSameDay(as: Date()) {
            return "Today, \(formatter.string(from: selectedDate))"
        }
        return formatter.string(from: selectedDate)
    }

        private func togglePaid(_ sub: Subscription) {
            // 1. Immediate Visual Feedback
            withAnimation {
                sub.isPaid.toggle()
            }
            
            // 2. If we just marked it as paid, advance the date after a short delay
            if sub.isPaid {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        sub.advanceBillingDate()
                        // This will cause the item to move to the next month's calendar date
                        NotificationManager.shared.scheduleNotification(for: sub)
                    }
                }
            }
        }
}
