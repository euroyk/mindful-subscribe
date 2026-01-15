//
//  SettingsView.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 23/11/2568 BE.
//

import SwiftUI

struct SettingsView: View {
    // App Settings
    @AppStorage("currency") private var currency: String = "THB"
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    
    // State for alerts
    @State private var showDeleteConfirmation = false
    
    // Access the SwiftData Context to delete data
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Custom Header to use Hoefler Text
                        Text("Settings")
                            .font(Theme.headingFont(size: 34))
                            .foregroundColor(Theme.headingText)
                            .padding(.top, 10)
                        
                        // Section 1: Preferences
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Preferences")
                                .font(Theme.bodyFont(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                                .padding(.leading, 4)
                            
                            VStack(spacing: 0) {
                                // Currency Picker Row
                                HStack {
                                    Text("Currency")
                                        .font(Theme.bodyFont(size: 16))
                                        .foregroundColor(Theme.headingText)
                                    Spacer()
                                    Picker("Currency", selection: $currency) {
                                        Text("THB (฿)").tag("THB")
                                        Text("USD ($)").tag("USD")
                                        Text("JPY (¥)").tag("JPY")
                                    }
                                    .tint(Theme.headingText) // Changes picker text color
                                    .labelsHidden()
                                }
                                .padding()
                                
                                Divider()
                                    .background(Color.gray.opacity(0.2))
                                
                                // Notification Toggle Row
                                Toggle("Enable Notifications", isOn: $notificationsEnabled)
                                    .font(Theme.bodyFont(size: 16))
                                    .foregroundColor(Theme.headingText)
                                    .tint(Theme.currentDayCircle) // Use Sage Green
                                    .padding()
                            }
                            .background(Theme.itemBox)
                            .cornerRadius(Theme.cornerRadius) // Uses radius 20
                        }
                        
                        // Section 2: Data Management
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Data")
                                .font(Theme.bodyFont(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                                .padding(.leading, 4)
                            
                            Button(action: {
                                showDeleteConfirmation = true
                            }) {
                                HStack {
                                    Text("Clear All Data")
                                        .font(Theme.bodyFont(size: 16, weight: .medium))
                                        .foregroundColor(.red)
                                    Spacer()
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .padding()
                                .background(Theme.itemBox)
                                .cornerRadius(Theme.cornerRadius) // Uses radius 20
                            }
                        }
                        
                        // Section 3: About
                        VStack(spacing: 8) {
                            Text("Mindful Subscribe")
                                .font(Theme.headingFont(size: 20))
                                .foregroundColor(Theme.headingText.opacity(0.8))
                            Text("Version 1.0.0")
                                .font(Theme.bodyFont(size: 14))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                        
                        Spacer()
                    }
                    .padding(20)
                }
            }
            // Hide standard navigation title to use our custom Hoefler Text one
            .navigationBarHidden(true)
            .alert("Clear All Data?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    clearAllData()
                }
            } message: {
                Text("This action cannot be undone. All subscriptions and reflection logs will be permanently deleted.")
            }
        }
    }
    
    private func clearAllData() {
        do {
            try modelContext.delete(model: Subscription.self)
            try modelContext.delete(model: ReflectionLog.self)
            print("All data cleared successfully")
        } catch {
            print("Failed to clear data: \(error)")
        }
    }
}
