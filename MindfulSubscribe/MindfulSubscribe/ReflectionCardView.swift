//
//  ReflectionCardView.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 23/11/2568 BE.
//

import SwiftUI

struct ReflectionCardView: View {
    let subscription: Subscription
    var onSave: (ValueRating) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(Theme.headingText)
                Text("Worth It Check")
                    .font(Theme.headingFont(size: 18))
                    .foregroundColor(Theme.headingText)
                Spacer()
            }
            
            Text("How was **\(subscription.name)** this month?")
                .font(Theme.bodyFont(size: 16))
                .foregroundColor(.black.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 12) {
                OptionButton(emoji: "🔥", label: "Daily", color: Theme.currentDayCircle) {
                    onSave(.highValue)
                }
                
                OptionButton(emoji: "🙂", label: "Sometimes", color: Color.orange.opacity(0.7)) {
                    onSave(.mediumValue)
                }
                
                OptionButton(emoji: "🕸️", label: "Barely", color: Color.gray) {
                    onSave(.lowValue)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(Theme.cornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                .stroke(Theme.headingText.opacity(0.2), lineWidth: 1)
        )
    }
}

struct OptionButton: View {
    let emoji: String
    let label: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(emoji).font(.title)
                Text(label).font(Theme.bodyFont(size: 12, weight: .bold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(color.opacity(0.2))
            .foregroundColor(Color.black)
            .cornerRadius(15)
        }
    }
}
