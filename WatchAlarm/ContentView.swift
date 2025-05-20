import SwiftUI

struct ContentView: View {
    @State private var pin: String = ""
    @State private var alarmTime: Date = Date().addingTimeInterval(60) // default: 1 min ahead
    @StateObject private var appState = AppState.shared

    var body: some View {
    NavigationStack {
        Form {
            Section(header: Text("Set Alarm Time")) {
                DatePicker("Alarm Time", selection: $alarmTime, displayedComponents: .hourAndMinute)
            }

            Section(header: Text("Enter PIN")) {
                TextField("PIN", text: $pin)
                    .keyboardType(.numberPad)
            }

            Button("Schedule Alarm") {
                scheduleAlarm()
            }
            .disabled(pin.count != 4)

            Section {
                NavigationLink("Enter PIN to Disable Alarm", destination: PINVerificationView())
                    .disabled(!appState.isAlarmActive)
            }
        }
        .navigationTitle("Alarm Settings")
    }
}

    func scheduleAlarm() {
        let now = Date()
        let interval = alarmTime.timeIntervalSince(now)

        guard interval > 0 else {
            print("⚠️ Cannot schedule alarm in the past")
            return
        }

        AppState.shared.scheduledPIN = pin
        AppState.shared.isAlarmActive = true

        print("⏰ Alarm scheduled for \(alarmTime)")

        Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            print("🚨 Alarm triggered — sending PIN: \(pin)")
            ConnectivityManager.shared.sendPINToWatch(pin: pin)
        }
    }
}
