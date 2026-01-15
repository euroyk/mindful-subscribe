//
//  DayCellView.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 21/11/2568 BE.
//

import SwiftUI

struct DayCellView: View {
    let date: Date
    let isSelected: Bool
    let hasDue: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                if date.isSameDay(as: Date()) {
                    Circle()
                        .fill(Theme.currentDayCircle)
                        .frame(width: 35, height: 35)
                } else if isSelected {
                    Circle()
                        .stroke(Theme.headingText, lineWidth: 2)
                        .frame(width: 35, height: 35)
                }
                
                Text("\(date.day)")
                    .font(Theme.bodyFont(size: 16, weight: isSelected || date.isSameDay(as: Date()) ? .bold : .regular))
                    .foregroundColor(getDateColor())
            }
            
            // Due Indicator Dot
            Circle()
                .fill(hasDue ? Color.gray : Color.clear)
                .frame(width: 5, height: 5)
        }
        .frame(height: 50)
    }
    
    private func getDateColor() -> Color {
        if date.isSameDay(as: Date()) {
            return .white
        } else if date.isPast() {
            return .gray
        } else {
            return Theme.headingText
        }
    }
}
