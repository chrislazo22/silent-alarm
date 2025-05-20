import SwiftUI

@main
struct WatchAlarmApp: App {
    @StateObject private var notificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notificationManager)
                .task {
                    await notificationManager.requestAuthorization()
                }
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = AlarmViewModel()
    @State private var showingNewAlarm = false
    @State private var editingAlarm: Alarm?
    @State private var newAlarmTime = Date()
    @State private var newAlarmIsRepeating = false
    @State private var newAlarmRepeatDays: Set<Alarm.Weekday> = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.alarms) { alarm in
                    AlarmRow(alarm: alarm, viewModel: viewModel) {
                        editingAlarm = alarm
                        newAlarmTime = alarm.time
                        newAlarmIsRepeating = !alarm.repeatDays.isEmpty
                        newAlarmRepeatDays = alarm.repeatDays
                        showingNewAlarm = true
                    }
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
                        editingAlarm = nil
                        newAlarmTime = Date()
                        newAlarmIsRepeating = false
                        newAlarmRepeatDays = []
                        showingNewAlarm = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewAlarm) {
            NavigationStack {
                AlarmSettingsView(
                    time: $newAlarmTime,
                    isRepeating: $newAlarmIsRepeating,
                    repeatDays: $newAlarmRepeatDays
                )
                .navigationTitle(editingAlarm == nil ? "New Alarm" : "Edit Alarm")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            showingNewAlarm = false
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            if let alarm = editingAlarm {
                                var updatedAlarm = alarm
                                updatedAlarm.time = newAlarmTime
                                updatedAlarm.repeatDays = newAlarmIsRepeating ? newAlarmRepeatDays : []
                                viewModel.updateAlarm(updatedAlarm)
                            } else {
                                viewModel.createAlarm(
                                    time: newAlarmTime,
                                    isRepeating: newAlarmIsRepeating,
                                    repeatDays: newAlarmRepeatDays
                                )
                            }
                            showingNewAlarm = false
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
    let onEdit: () -> Void
    
    var body: some View {
        Button(action: onEdit) {
            HStack {
                VStack(alignment: .leading) {
                    Text(alarm.time, style: .time)
                        .font(.title2)
                        .foregroundColor(.primary)
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
                .labelsHidden()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
} 