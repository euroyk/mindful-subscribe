//
//  CalendarHeaderView.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 21/11/2568 BE.
//

import SwiftUI

struct CalendarHeaderView: View {
    @Binding var currentMonth: Date
    @State private var showDatePicker = false
    
    var body: some View {
        HStack {
            // Previous Month
            Button(action: {
                withAnimation {
                    currentMonth = currentMonth.changeMonth(by: -1)
                }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(Theme.headingText)
            }
            
            Spacer()
            
            // Month Title (Tappable)
            Button(action: {
                showDatePicker = true
            }) {
                Text(currentMonth.formatMonthYear())
                    .font(Theme.headingFont(size: 20))
                    .foregroundColor(Theme.headingText)
            }
            .sheet(isPresented: $showDatePicker) {
                VStack {
                    DatePicker("Select Month", selection: $currentMonth, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                    
                    Button("Done") {
                        showDatePicker = false
                    }
                    .font(Theme.bodyFont(size: 18, weight: .bold))
                    .padding()
                }
                .presentationDetents([.medium])
            }
            
            Spacer()
            
            // Next Month
            Button(action: {
                withAnimation {
                    currentMonth = currentMonth.changeMonth(by: 1)
                }
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.headingText)
            }
        }
        .padding(.horizontal)
    }
}
