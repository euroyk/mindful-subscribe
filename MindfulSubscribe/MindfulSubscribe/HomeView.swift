//
//  HomeView.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 20/11/2568 BE.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Subscription.nextBillingDate, order: .forward) private var subscriptions: [Subscription]
    
    // User Settings
    @AppStorage("userName") private var userName: String = "Friend"
    @AppStorage("shouldShowAddSheetOnLaunch") private var shouldShowAddSheetOnLaunch: Bool = false
    
    // UI State
    @State private var showAddSubscription = false
    
    // Computed property to find the first subscription needing reflection
    var subscriptionToReflect: Subscription? {
        subscriptions.first { ReflectionService.needsReflection(for: $0) }
    }
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // 1. Greeting Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hello, \(userName) 😊")
                            .font(Theme.headingFont(size: 32))
                            .foregroundColor(Theme.headingText)
                        
                        Text("Here's your subscription insight")
                            .font(Theme.bodyFont(size: 16))
                            .foregroundColor(.gray)
                    }
                    .padding(.top)
                    
                    if subscriptions.isEmpty {
                        emptyStateView
                    } else {
                        // *** Reflection Card Section ***
                        if let sub = subscriptionToReflect {
                            ReflectionCardView(subscription: sub) { rating in
                                saveReflection(for: sub, rating: rating)
                            }
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        
                        // 2. Insight Box
                        InsightCardView(subscriptions: subscriptions)
                        
                        // 3. Subscription Lists
                        VStack(alignment: .leading, spacing: 16) {
                            sectionHeader(title: "Your Subscriptions")
                            
                            ForEach(subscriptions) { sub in
                                SubscriptionRowView(sub: sub, onCheck: {
                                    handlePayment(for: sub)
                                })
                                .overlay(alignment: .bottom) {
                                    if let nudge = ReflectionService.getNudgeMessage(for: sub) {
                                        Text(nudge)
                                            .font(Theme.bodyFont(size: 10))
                                            .padding(8)
                                            .background(Color.yellow.opacity(0.2))
                                            .cornerRadius(8)
                                            .offset(y: 10)
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 100)
                    }
                }
                .padding()
            }
            
            // Floating Action Button (FAB)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { showAddSubscription = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Theme.headingText)
                            .clipShape(Circle())
                            .shadow(radius: 4, y: 2)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 90) // Raised slightly above TabBar (approx height)
                }
            }
        }
        .animation(.spring(), value: subscriptionToReflect)
        .sheet(isPresented: $showAddSubscription) {
            AddSubscriptionView()
                .presentationDetents([.large]) // Or .medium if you prefer
        }
        .onAppear {
            checkAutoLaunchSheet()
        }
    }
    
    // MARK: - Logic
    
    private func checkAutoLaunchSheet() {
        if shouldShowAddSheetOnLaunch {
            // Delay slightly to ensure view is loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showAddSubscription = true
                shouldShowAddSheetOnLaunch = false // Reset flag
            }
        }
    }
    
    private func saveReflection(for sub: Subscription, rating: ValueRating) {
        let newLog = ReflectionLog(valueRating: rating)
        sub.reflectionLogs.append(newLog)
        try? modelContext.save()
    }
    
    private func sectionHeader(title: String) -> some View {
        Text(title)
            .font(Theme.headingFont(size: 22))
            .foregroundColor(Theme.headingText)
            .padding(.top, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("No subscriptions found")
                .font(Theme.bodyFont(size: 18))
            
            Button(action: { showAddSubscription = true }) {
                Text("Add Subscription")
                    .font(Theme.bodyFont(size: 16, weight: .bold))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Theme.headingText)
                    .foregroundColor(.white)
                    .cornerRadius(Theme.cornerRadius)
            }
            Spacer()
        }
        .padding(.top, 50)
    }
    private func handlePayment(for sub: Subscription) {
        // 1. Visual toggle
        withAnimation {
            sub.isPaid.toggle()
        }
        
        // 2. Logic: If paid, advance date after delay
        if sub.isPaid {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    sub.advanceBillingDate()
                    NotificationManager.shared.scheduleNotification(for: sub)
                }
            }
        }
    }
}
