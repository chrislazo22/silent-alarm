import Foundation
import WatchConnectivity
#if os(watchOS)
import WatchKit
#endif

class ConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = ConnectivityManager()

    @Published var receivedPIN: String = "----"

    private override init() {
        super.init()
        activateSession()
    }

    private func activateSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func sendPINToWatch(pin: String) {
        guard WCSession.default.activationState == .activated else {
            print("⚠️ WCSession not yet activated")
            return
        }

        do {
            try WCSession.default.updateApplicationContext(["pin": pin])
            print("✅ Sent PIN via updateApplicationContext: \(pin)")
        } catch {
            print("❌ Failed to update application context: \(error.localizedDescription)")
        }
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            if let pin = applicationContext["pin"] as? String {
                self.receivedPIN = pin

                #if os(watchOS)
                print("🔔 Playing haptic")
                WKInterfaceDevice.current().play(.notification)
                #endif
            }
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("✅ WCSession activated with state: \(activationState.rawValue)")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession did deactivate")
    }
}
