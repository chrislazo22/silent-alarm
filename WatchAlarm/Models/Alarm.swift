import Foundation

struct Alarm: Identifiable, Codable, Equatable {
    let id: UUID
    var time: Date
    var isEnabled: Bool
    var repeatDays: Set<Weekday>
    
    init(id: UUID = UUID(), time: Date, isEnabled: Bool = true, repeatDays: Set<Weekday> = []) {
        self.id = id
        self.time = time
        self.isEnabled = isEnabled
        self.repeatDays = repeatDays
    }
}

// MARK: - Weekday Enum
extension Alarm {
    enum Weekday: Int, Codable, CaseIterable {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
        
        var shortName: String {
            switch self {
            case .sunday: return "Sun"
            case .monday: return "Mon"
            case .tuesday: return "Tue"
            case .wednesday: return "Wed"
            case .thursday: return "Thu"
            case .friday: return "Fri"
            case .saturday: return "Sat"
            }
        }
    }
}

// MARK: - Helper Methods
extension Alarm {
    var isRepeating: Bool {
        !repeatDays.isEmpty
    }
    
    var nextAlarmTime: Date {
        // If alarm is repeating, calculate next occurrence
        // If not repeating, return the set time
        // TODO: Implement next occurrence calculation
        time
    }
    
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        lhs.id == rhs.id &&
        lhs.time == rhs.time &&
        lhs.isEnabled == rhs.isEnabled &&
        lhs.repeatDays == rhs.repeatDays
    }
} 