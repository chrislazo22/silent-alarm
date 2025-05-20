import Foundation

class AppState: ObservableObject {
    static let shared = AppState()

    @Published var scheduledPIN: String = "----"
    @Published var isAlarmActive: Bool = false
}
