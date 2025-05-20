import Foundation
import WatchConnectivity
#if os(watchOS)
import WatchKit
#endif

class ConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = ConnectivityManager()

    @Published var receivedPIN: String = "----"
    private var isActivated = false
    private var pendingPIN: String?

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
        if WCSession.default.activationState == .activated {
            do {
                try WCSession.default.updateApplicationContext(["pin": pin])
                print("✅ Sent PIN via updateApplicationContext: \(pin)")
            } catch {
                print("❌ Failed to update application context: \(error.localizedDescription)")
            }
        } else {
            print("⏳ Session not yet activated — will send PIN after activation")
            pendingPIN = pin
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
        isActivated = true

        if let pin = pendingPIN {
            print("📦 Sending pending PIN after activation: \(pin)")
            sendPINToWatch(pin: pin)
            pendingPIN = nil
        }
    }

    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession did deactivate")
    }
    #endif
}
