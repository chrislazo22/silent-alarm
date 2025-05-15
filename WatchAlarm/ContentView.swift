import SwiftUI

struct ContentView: View {
    @State private var pin: String = ""
    @State private var alarmTime: Date = Date().addingTimeInterval(60) // default: 1 min ahead

    var body: some View {
        NavigationView {
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
            }
            .navigationTitle("Alarm Settings")
        }
    }

    func scheduleAlarm() {
        let now = Date()
        let interval = alarmTime.timeIntervalSince(now)

        if interval <= 0 {
            print("⚠️ Cannot schedule alarm in the past")
            return
        }

        print("⏰ Alarm scheduled for \(alarmTime) (in \(Int(interval)) seconds)")

        Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            print("🚨 Alarm triggered — sending PIN: \(pin)")
            ConnectivityManager.shared.sendPINToWatch(pin: pin)
        }
    }
}
