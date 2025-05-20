import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    static var sharedPin: String = "----"

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // Called when the alarm fires while app is in foreground or background
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        let pin = AppDelegate.sharedPin
        print("📲 Alarm fired. Sending PIN \(pin) to watch.")
        ConnectivityManager.shared.sendPINToWatch(pin: pin)
        completionHandler()
    }
}
