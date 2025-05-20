import Foundation
import UserNotifications

@MainActor
class NotificationManager: ObservableObject {
    @Published private(set) var isAuthorized = false
    @Published var errorMessage: String?
    
    private let center = UNUserNotificationCenter.current()
    
    init() {
        Task {
            await checkAuthorizationStatus()
        }
    }
    
    func requestAuthorization() async {
        do {
            let options: UNAuthorizationOptions = [.alert, .sound, .badge]
            isAuthorized = try await center.requestAuthorization(options: options)
        } catch {
            errorMessage = "Failed to request notification authorization: \(error.localizedDescription)"
        }
    }
    
    private func checkAuthorizationStatus() async {
        let settings = await center.notificationSettings()
        isAuthorized = settings.authorizationStatus == .authorized
    }
} 
