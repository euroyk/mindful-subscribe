//
//  SubscriptionRowView.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 20/11/2568 BE.
//

import SwiftUI

struct SubscriptionRowView: View {
    let sub: Subscription
    var onCheck: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 12) {
            // Logo / Icon
            Image(systemName: sub.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .padding(10)
                .background(Color.white.opacity(0.5))
                .clipShape(Circle())
            
            // Name & Cycle
            VStack(alignment: .leading, spacing: 4) {
                Text(sub.name)
                    .font(Theme.bodyFont(size: 16, weight: .semibold))
                    .strikethrough(sub.isPaid)
                    .opacity(sub.isPaid ? 0.6 : 1.0)
                
                Text(sub.billingCycle.rawValue) // Updated to use BillingCycle
                    .font(Theme.bodyFont(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Price & Due Date or Checkbox
            HStack(spacing: 12) {
                VStack(alignment: .trailing, spacing: 4) {
                    Text("฿\(String(format: "%.2f", sub.cost))") // Updated to use cost
                        .font(Theme.bodyFont(size: 16, weight: .bold))
                        .opacity(sub.isPaid ? 0.6 : 1.0)
                    
                    if let warning = sub.dueWarningText, !sub.isPaid {
                        Text(warning)
                            .font(Theme.bodyFont(size: 12, weight: .bold))
                            .foregroundColor(.red)
                    } else {
                        Text(formattedDate(sub.nextBillingDate)) // Updated to use nextBillingDate
                            .font(Theme.bodyFont(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                // Checkbox Section
                if let onCheck = onCheck {
                    Button(action: onCheck) {
                        Image(systemName: sub.isPaid ? "checkmark.square.fill" : "square")
                            .font(.system(size: 24))
                            .foregroundColor(sub.isPaid ? Theme.currentDayCircle : .gray)
                    }
                }
            }
        }
        .padding()
        .background(Theme.itemBox)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: date)
    }
}
