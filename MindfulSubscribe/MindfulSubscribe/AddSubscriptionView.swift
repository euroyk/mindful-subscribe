//
//  AddSubscriptionView.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 23/11/2568 BE.
//

import SwiftUI
import SwiftData

struct AddSubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    // Form States
    @State private var name: String = ""
    @State private var cost: Double = 0.0
    @State private var currency: String = "THB"
    @State private var billingCycle: BillingCycle = .monthly
    @State private var nextBillingDate: Date = Date()
    @State private var category: Category = .entertainment
    @State private var iconName: String = "sparkles"
    @State private var notificationsEnabled: Bool = true
    
    // Currencies List
    let currencies = ["THB", "USD", "JPY", "EUR", "GBP"]
    
    // Simple Icon Picker Options
    let icons = ["sparkles", "tv.fill", "music.note", "gamecontroller.fill", "briefcase.fill", "bolt.fill", "heart.fill", "cloud.fill"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Icon Picker Section
                        VStack {
                            Image(systemName: iconName)
                                .font(.system(size: 40))
                                .foregroundColor(Theme.currentDayCircle) // Using Sage/Green from Theme
                                .padding()
                                .background(Theme.itemBox)
                                .clipShape(Circle())
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(icons, id: \.self) { icon in
                                        Circle()
                                            .fill(iconName == icon ? Theme.headingText : Theme.itemBox)
                                            .frame(width: 44, height: 44)
                                            .overlay(
                                                Image(systemName: icon)
                                                    .foregroundColor(iconName == icon ? .white : .gray)
                                            )
                                            .onTapGesture {
                                                withAnimation { iconName = icon }
                                            }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                        
                        // Form Fields
                        VStack(spacing: 20) {
                            
                            // Name
                            InputGroup(label: "Service Name") {
                                TextField("e.g. Netflix", text: $name)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding()
                                    .background(Theme.itemBox)
                                    .cornerRadius(12)
                            }
                            
                            // Cost & Currency
                            HStack(spacing: 12) {
                                InputGroup(label: "Cost") {
                                    TextField("0.00", value: $cost, format: .number)
                                        .keyboardType(.decimalPad)
                                        .padding()
                                        .background(Theme.itemBox)
                                        .cornerRadius(12)
                                }
                                
                                InputGroup(label: "Currency") {
                                    Picker("", selection: $currency) {
                                        ForEach(currencies, id: \.self) { curr in
                                            Text(curr).tag(curr)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Theme.itemBox)
                                    .cornerRadius(12)
                                }
                            }
                            
                            // Cycle & Category
                            HStack(spacing: 12) {
                                InputGroup(label: "Cycle") {
                                    Picker("", selection: $billingCycle) {
                                        ForEach(BillingCycle.allCases, id: \.self) { cycle in
                                            Text(cycle.rawValue).tag(cycle)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Theme.itemBox)
                                    .cornerRadius(12)
                                }
                                
                                InputGroup(label: "Category") {
                                    Picker("", selection: $category) {
                                        ForEach(Category.allCases, id: \.self) { cat in
                                            Text(cat.rawValue).tag(cat)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Theme.itemBox)
                                    .cornerRadius(12)
                                }
                            }
                            
                            // Date
                            InputGroup(label: "Next Billing Date") {
                                DatePicker("", selection: $nextBillingDate, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Theme.itemBox)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationTitle("New Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.gray)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveSubscription()
                    }
                    .disabled(name.isEmpty)
                    .fontWeight(.bold)
                    .foregroundColor(name.isEmpty ? .gray : Theme.headingText)
                }
            }
        }
    }
    
    private func saveSubscription() {
        let newSub = Subscription(
            name: name,
            iconName: iconName,
            cost: cost,
            currency: currency,
            billingCycle: billingCycle,
            nextBillingDate: nextBillingDate,
            category: category,
            notificationsEnabled: notificationsEnabled
        )
        
        modelContext.insert(newSub)
        
        NotificationManager.shared.scheduleNotification(for: newSub)
        
        // Explicitly try to save if needed, though SwiftData usually autosaves
        try? modelContext.save()
        
        dismiss()
    }
}

// Helper View for consistent labeling
struct InputGroup<Content: View>: View {
    let label: String
    let content: Content
    
    init(label: String, @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(Theme.bodyFont(size: 14, weight: .semibold))
                .foregroundColor(.gray)
                .padding(.leading, 4)
            content
        }
    }
}
