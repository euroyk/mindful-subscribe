//
//  InsightCardView.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 20/11/2568 BE.
//

import SwiftUI

struct InsightCardView: View {
    let subscriptions: [Subscription]
    
    var totalCost: Double {
        subscriptions.reduce(0) { $0 + $1.cost }
    }
    
    var nearDueCount: Int {
        subscriptions.filter { $0.dueWarningText != nil }.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Overview")
                .font(Theme.headingFont(size: 20))
                .foregroundColor(Theme.headingText)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Total Expense")
                        .font(Theme.bodyFont(size: 14))
                    Text("฿\(String(format: "%.2f", totalCost))")
                        .font(Theme.bodyFont(size: 32, weight: .bold))
                    
                    if nearDueCount > 0 {
                        Text("\(nearDueCount) bills nearby")
                            .font(Theme.bodyFont(size: 14, weight: .medium))
                            .foregroundColor(.red)
                    } else {
                         Text("All bills paid")
                             .font(Theme.bodyFont(size: 14))
                             .foregroundColor(.green)
                    }
                }
                
                Spacer()
                
                // Pie Chart Area
                if !subscriptions.isEmpty {
                    PieChartView(subscriptions: subscriptions)
                        .frame(width: 120, height: 120)
                }
            }
        }
        .padding()
        .background(Theme.insightBox)
        .cornerRadius(Theme.cornerRadius)
    }
}
