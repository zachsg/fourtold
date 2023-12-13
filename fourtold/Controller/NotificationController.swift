//
//  NotificationController.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/12/23.
//

import Foundation
import UserNotifications

class NotificationController {
    static let notificationCenter = UNUserNotificationCenter.current()
    
    static func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    static func scheduleNotification(title: String, subtitle: String, timeInSeconds: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInSeconds), repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    static func cancelAllPending() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
}
