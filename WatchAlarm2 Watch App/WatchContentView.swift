import SwiftUI

struct WatchContentView: View {
    @StateObject private var connectivity = ConnectivityManager.shared

    var body: some View {
        VStack {
            Text("Your PIN")
                .font(.headline)
            Text(connectivity.receivedPIN)
                .font(.largeTitle)
                .bold()
        }
        .onAppear {
            _ = connectivity // activate session
        }
    }
}
