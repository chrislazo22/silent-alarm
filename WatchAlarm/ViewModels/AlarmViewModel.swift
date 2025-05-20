import Foundation
import Combine

@MainActor
class AlarmViewModel: ObservableObject {
    @Published private(set) var alarms: [Alarm] = []
    @Published var currentAlarm: Alarm?
    @Published var errorMessage: String?
    
    private var userDefaults: UserDefaults
    private let alarmsKey = "savedAlarms"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        loadAlarms()
    }
    
    // MARK: - Public Methods
    
    func setUserDefaults(_ userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        loadAlarms()
    }
    
    func createAlarm(time: Date, isRepeating: Bool, repeatDays: Set<Alarm.Weekday>) {
        let alarm = Alarm(
            time: time,
            isEnabled: true,
            repeatDays: isRepeating ? repeatDays : []
        )
        
        alarms.append(alarm)
        saveAlarms()
    }
    
    func updateAlarm(_ alarm: Alarm) {
        guard let index = alarms.firstIndex(where: { $0.id == alarm.id }) else {
            errorMessage = "Alarm not found"
            return
        }
        
        alarms[index] = alarm
        saveAlarms()
    }
    
    func deleteAlarm(_ alarm: Alarm) {
        alarms.removeAll { $0.id == alarm.id }
        saveAlarms()
    }
    
    func toggleAlarm(_ alarm: Alarm) {
        var updatedAlarm = alarm
        updatedAlarm.isEnabled.toggle()
        updateAlarm(updatedAlarm)
    }
    
    // MARK: - Private Methods
    
    private func loadAlarms() {
        guard let data = userDefaults.data(forKey: alarmsKey) else { return }
        
        do {
            alarms = try JSONDecoder().decode([Alarm].self, from: data)
        } catch {
            errorMessage = "Failed to load alarms: \(error.localizedDescription)"
        }
    }
    
    private func saveAlarms() {
        do {
            let data = try JSONEncoder().encode(alarms)
            userDefaults.set(data, forKey: alarmsKey)
        } catch {
            errorMessage = "Failed to save alarms: \(error.localizedDescription)"
        }
    }
}

// MARK: - Preview Helper
extension AlarmViewModel {
    static var preview: AlarmViewModel {
        let viewModel = AlarmViewModel()
        viewModel.createAlarm(
            time: Date(),
            isRepeating: true,
            repeatDays: [.monday, .wednesday, .friday]
        )
        return viewModel
    }
} 