//
//  MindfulSubscribeApp.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 20/11/2568 BE.
//

import SwiftUI
import SwiftData

@main
struct MindfulSubscribeApp: App {
    // Setup SwiftData Container
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Subscription.self, ReflectionLog.self)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
        NotificationManager.shared.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
