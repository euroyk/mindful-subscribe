//
//  OnboardingView.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 23/11/2568 BE.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingComplete: Bool
    @State private var currentTab = 0
    
    // New: Store the name locally before saving to AppStorage
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("shouldShowAddSheetOnLaunch") private var shouldShowAddSheetOnLaunch: Bool = false
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            TabView(selection: $currentTab) {
                // Screen 1: Welcome
                OnboardingPage(
                    imageName: "leaf.fill",
                    title: "Hello! Nice to meet you.",
                    description: "Let's organize your digital life to be lighter and freer.",
                    pageIndex: 0,
                    action: { withAnimation { currentTab = 1 } }
                )
                .tag(0)
                
                // Screen 2: Name Input (NEW)
                OnboardingNamePage(
                    name: $userName,
                    action: { withAnimation { currentTab = 2 } }
                )
                .tag(1)
                
                // Screen 3: Value Prop
                OnboardingPage(
                    imageName: "hourglass.bottomhalf.filled",
                    title: "Mindful Management",
                    description: "We know subscriptions can be overwhelming. We'll help you remember what to pay and when.",
                    pageIndex: 2,
                    action: { withAnimation { currentTab = 3 } }
                )
                .tag(2)
                
                // Screen 4: CTA
                OnboardingPage(
                    imageName: "checkmark.seal.fill",
                    title: "Ready to Start?",
                    description: "Add your first service and begin your mindful journey.",
                    pageIndex: 3,
                    isLastPage: true,
                    action: {
                        // Logic: Finish onboarding AND trigger the sheet in HomeView
                        shouldShowAddSheetOnLaunch = true
                        withAnimation {
                            isOnboardingComplete = true
                        }
                    }
                )
                .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
}

// Special Page for Name Input
struct OnboardingNamePage: View {
    @Binding var name: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(Theme.currentDayCircle)
            
            VStack(spacing: 16) {
                Text("What should we call you?")
                    .font(Theme.headingFont(size: 28))
                    .foregroundColor(Theme.headingText)
                
                TextField("Your Name", text: $name)
                    .font(Theme.bodyFont(size: 20))
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Theme.itemBox)
                    .cornerRadius(Theme.cornerRadius)
                    .padding(.horizontal, 40)
                    .submitLabel(.next)
                    .onSubmit(action)
            }
            
            Spacer()
            
            Button(action: action) {
                Text("Next")
                    .font(Theme.bodyFont(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(name.isEmpty ? Color.gray : Theme.headingText)
                    .cornerRadius(Theme.cornerRadius)
            }
            .disabled(name.isEmpty)
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
}

struct OnboardingPage: View {
    let imageName: String
    let title: String
    let description: String
    let pageIndex: Int
    var isLastPage: Bool = false
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(Theme.currentDayCircle)
                .padding(30)
                .background(Theme.itemBox)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 16) {
                Text(title)
                    .font(Theme.headingFont(size: 28))
                    .foregroundColor(Theme.headingText)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(Theme.bodyFont(size: 18))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            Button(action: action) {
                Text(isLastPage ? "Add Your First Service" : "Next")
                    .font(Theme.bodyFont(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.headingText)
                    .cornerRadius(Theme.cornerRadius)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
}
