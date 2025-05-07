import Foundation
import WatchConnectivity

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

    // Send PIN to Watch
    func sendPINToWatch(pin: String) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["pin": pin], replyHandler: nil, errorHandler: nil)
        }
    }

    // Receive PIN on Watch
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let pin = message["pin"] as? String {
                self.receivedPIN = pin
            }
        }
    }

    // Required stubs
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
#endif
}
