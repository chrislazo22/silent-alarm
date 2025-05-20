import SwiftUI

@main
struct WatchAlarmApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var time = Date()
    @State private var isRepeating = false
    @State private var repeatDays: Set<Alarm.Weekday> = []
    
    var body: some View {
        NavigationView {
            AlarmSettingsView(
                time: $time,
                isRepeating: $isRepeating,
                repeatDays: $repeatDays
            )
            .navigationTitle("Set Alarm")
        }
    }
}

#Preview {
    ContentView()
} 