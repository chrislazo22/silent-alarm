import SwiftUI

struct PINVerificationView: View {
    @State private var enteredPIN: String = ""
    @State private var correctPIN: String = AppState.shared.scheduledPIN
    @State private var resultMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter PIN to Disable Alarm")
                .font(.headline)

            SecureField("4-digit PIN", text: $enteredPIN)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .frame(maxWidth: 200)

            Button("Submit") {
                validatePIN()
            }
            .disabled(enteredPIN.count != 4)

            if let result = resultMessage {
                Text(result)
                    .foregroundColor(result == "Alarm disabled ✅" ? .green : .red)
            }
        }
        .padding()
    }

    func validatePIN() {
        if enteredPIN == correctPIN {
            resultMessage = "Alarm disabled ✅"
            AppState.shared.isAlarmActive = false
        } else {
            resultMessage = "Incorrect PIN ❌"
        }
    }
}
