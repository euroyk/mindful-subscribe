//
//  ContentView.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 20/11/2568 BE.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    var body: some View {
        if hasSeenOnboarding {
            MainTabView()
        } else {
            OnboardingView(isOnboardingComplete: $hasSeenOnboarding)
        }
    }
}
