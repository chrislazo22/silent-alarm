import SwiftUI

struct ContentView: View {
    @State private var pin: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter Alarm PIN")) {
                    TextField("4-digit PIN", text: $pin)
                        .keyboardType(.numberPad)
                }

                Button("Send PIN to Watch") {
                    ConnectivityManager.shared.sendPINToWatch(pin: pin)
                }
                .disabled(pin.count != 4)
            }
            .navigationTitle("Alarm Settings")
        }
    }
}
