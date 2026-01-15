//
//  NotificationManager.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 25/11/2568 BE.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    // กำหนดวันล่วงหน้าที่จะให้เตือน (7 วัน, 3 วัน, และ 1 วัน)
    private let alertDaysBefore = [7, 3, 1]
    
    // 1. ขออนุญาต
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    // 2. ตั้งเวลาแจ้งเตือน (แบบ Loop)
    func scheduleNotification(for subscription: Subscription) {
        // ล้างอันเก่าก่อนเสมอ เพื่อกันความซ้ำซ้อน
        cancelNotification(for: subscription)
        
        guard subscription.notificationsEnabled else { return }
        
        // วนลูปสร้างการแจ้งเตือนตามจำนวนวันที่เรากำหนดไว้ใน alertDaysBefore
        for daysBefore in alertDaysBefore {
            scheduleSingleNotification(for: subscription, daysBefore: daysBefore)
        }
    }
    
    // ฟังก์ชันย่อยสำหรับสร้างการแจ้งเตือน 1 รายการ
    private func scheduleSingleNotification(for subscription: Subscription, daysBefore: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Bill: \(subscription.name)"
        
        // ปรับข้อความให้เหมาะกับวันที่เตือน
        if daysBefore == 1 {
            content.body = "\(subscription.name) is due tomorrow! Amount: \(subscription.currency) \(Int(subscription.cost))"
        } else {
            content.body = "\(subscription.name) is due in \(daysBefore) days. Amount: \(subscription.currency) \(Int(subscription.cost))"
        }
        
        content.sound = .default
        
        // คำนวณวันที่แจ้งเตือน (ถอยหลังไปตามจำนวน daysBefore)
        guard let reminderDate = Calendar.current.date(byAdding: .day, value: -daysBefore, to: subscription.nextBillingDate) else { return }
        
        // ตรวจสอบว่าเป็นวันที่ในอนาคตหรือไม่ (ถ้าเวลาผ่านไปแล้วก็ไม่ต้องตั้ง)
        if reminderDate < Date() { return }
        
        var dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: reminderDate)
        dateComponents.hour = 9  // แจ้งเตือน 9 โมงเช้า
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // *** สำคัญ: สร้าง ID ที่ไม่ซ้ำกัน ***
        // เช่น "UUID-7", "UUID-3" เพื่อให้ระบบจำแยกกันได้
        let identifier = "\(subscription.id.uuidString)-\(daysBefore)"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling \(daysBefore)-day warning: \(error)")
            } else {
                print("Scheduled \(daysBefore)-day warning for \(subscription.name) at \(dateComponents)")
            }
        }
    }
    
    // 3. ยกเลิกแจ้งเตือน (ต้องลบทุก ID ที่เราเคยสร้าง)
    func cancelNotification(for subscription: Subscription) {
        // สร้างรายการ ID ทั้งหมดที่เป็นไปได้ (UUID-7, UUID-3, UUID-1)
        let identifiersToRemove = alertDaysBefore.map { "\(subscription.id.uuidString)-\($0)" }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
        print("Cancelled all notifications for \(subscription.name)")
    }
    
    // 4. ล้างทั้งหมด
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
