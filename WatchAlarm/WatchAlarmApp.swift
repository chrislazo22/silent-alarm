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
    var body: some View {
        Text("WatchAlarm")
            .padding()
    }
}

#Preview {
    ContentView()
} 