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
    @StateObject private var viewModel = AlarmViewModel()
    @State private var showingNewAlarm = false
    @State private var newAlarmTime = Date()
    @State private var newAlarmIsRepeating = false
    @State private var newAlarmRepeatDays: Set<Alarm.Weekday> = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.alarms) { alarm in
                    AlarmRow(alarm: alarm, viewModel: viewModel)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        viewModel.deleteAlarm(viewModel.alarms[index])
                    }
                }
            }
            .navigationTitle("Alarms")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        newAlarmTime = Date()
                        newAlarmIsRepeating = false
                        newAlarmRepeatDays = []
                        showingNewAlarm = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewAlarm) {
                NavigationView {
                    AlarmSettingsView(
                        time: $newAlarmTime,
                        isRepeating: $newAlarmIsRepeating,
                        repeatDays: $newAlarmRepeatDays
                    )
                    .navigationTitle("New Alarm")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                showingNewAlarm = false
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                viewModel.createAlarm(
                                    time: newAlarmTime,
                                    isRepeating: newAlarmIsRepeating,
                                    repeatDays: newAlarmRepeatDays
                                )
                                showingNewAlarm = false
                            }
                        }
                    }
                }
            }
        }
    }
}

struct AlarmRow: View {
    let alarm: Alarm
    @ObservedObject var viewModel: AlarmViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(alarm.time, style: .time)
                    .font(.title2)
                if alarm.isRepeating {
                    Text(alarm.repeatDays.sorted { $0.rawValue < $1.rawValue }
                        .map { $0.shortName }
                        .joined(separator: ", "))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Toggle("", isOn: Binding(
                get: { alarm.isEnabled },
                set: { _ in viewModel.toggleAlarm(alarm) }
            ))
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
} 