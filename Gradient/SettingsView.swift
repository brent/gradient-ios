//
//  SettingsView.swift
//  Gradient
//
//  Created by Brent Meyer on 3/7/22.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @State private var isReminderActive: Bool = UserDefaults.standard.bool(forKey: "isReminderActive")
    @State private var reminderTime: Date = ((UserDefaults.standard.object(forKey: "reminderTime") as? Date ?? Calendar.current.date(from: DateComponents(hour: 22, minute: 00))) ?? Date.now)

    var body: some View {
        List {
            Section {
                HStack {
                    Text("Reminder")
                    Spacer()
                    Toggle("Reminder", isOn: $isReminderActive)
                        .labelsHidden()
                        .onChange(of: isReminderActive) { newValue in
                            if newValue == true {
                                let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
                                addNotification(for: dateComponents)
                                UserDefaults.standard.set(true, forKey: "isReminderActive")
                            } else {
                                removeAllNotifications()
                                UserDefaults.standard.set(false, forKey: "isReminderActive")
                            }
                        }
                }

                HStack {
                    Text("Time")
                        .foregroundColor(isReminderActive ? .primary : .primary.opacity(0.5))
                    Spacer()
                    DatePicker("Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .disabled(isReminderActive == false)
                        .onChange(of: reminderTime) { newValue in
                            removeAllNotifications()
                            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
                            addNotification(for: dateComponents)
                            UserDefaults.standard.set(reminderTime, forKey: "reminderTime")
                        }
                }
            } header: {
                Text("Entry reminder")
            }

        }
    }

    func removeAllNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
    }

    func addNotification(for time: DateComponents) {
        let notificationCenter = UNUserNotificationCenter.current()

        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "How was your day?"
            content.body = "Take a moment to reflect"
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            notificationCenter.add(request)
        }

        notificationCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("Notification permission denied")
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
