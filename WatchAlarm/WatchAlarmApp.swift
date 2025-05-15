import SwiftUI
import UserNotifications

@main
struct WatchAlarmApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            print(granted ? "✅ Notification permission granted" : "❌ Permission denied")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
