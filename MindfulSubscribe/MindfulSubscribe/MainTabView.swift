//
//  MainTabView.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 23/11/2568 BE.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home, upcoming, settings
    }
    
    var body: some View {
        ZStack {
            // Background color for the whole app
            Theme.background.ignoresSafeArea()
            
            // Content Views
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .upcoming:
                    UpcomingView()
                case .settings:
                    SettingsView()
                }
            }
            
            // Custom Floating Tab Bar
            VStack {
                Spacer()
                HStack {
                    TabBarItem(icon: "house.fill", tab: .home, selectedTab: $selectedTab)
                    Spacer()
                    TabBarItem(icon: "calendar", tab: .upcoming, selectedTab: $selectedTab)
                    Spacer()
                    TabBarItem(icon: "gearshape.fill", tab: .settings, selectedTab: $selectedTab)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(Color.white)
                .cornerRadius(30)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
    }
}

struct TabBarItem: View {
    let icon: String
    let tab: MainTabView.Tab
    @Binding var selectedTab: MainTabView.Tab
    
    var isSelected: Bool { selectedTab == tab }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                selectedTab = tab
            }
        }) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(isSelected ? Theme.currentDayCircle : .gray.opacity(0.6))
                .scaleEffect(isSelected ? 1.2 : 1.0)
        }
    }
}

