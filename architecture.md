# Alarm Clock App Architecture

## Document Overview

This document outlines the technical architecture for a custom alarm clock application designed for iPhone and Apple Watch. The app's main goals are:

1. Silent, watch-only vibration alarms to avoid disturbing others.
2. A wake-up task mechanism (PIN entry) to reduce the likelihood of snoozing.

The app will be built in Swift and deployed via the Apple App Store with monetization considerations.

---

## 1. Tech Stack

### Frontend

- **iOS App:** Swift + SwiftUI
- **watchOS App:** Swift + SwiftUI
- **State Management:** Combine framework

### Backend (Optional, for analytics or pro features)

- **Serverless Backend (Optional):** Firebase / AWS Amplify
- **Database (Optional):** Firebase Firestore / AWS DynamoDB
- **Authentication (Optional):** Sign in with Apple / Firebase Auth

### Build & Deployment

- **CI/CD:** GitHub Actions / Bitrise
- **Distribution:** TestFlight & App Store Connect
- **Monetization:** StoreKit 2 (In-App Purchases / Subscriptions)

---

## 2. Folder + File Structure

```
AlarmClockApp/
├── AlarmClockAppApp.swift         # App entry point
├── Assets/                        # Images, colors, sounds
├── Models/
│   ├── Alarm.swift                # Alarm data model
│   └── Pin.swift                  # Random PIN model
├── Views/
│   ├── AlarmSettingsView.swift   # Main UI for setting alarms
│   ├── PinInputView.swift        # UI for entering PIN
│   └── WatchPinView.swift        # Watch UI to display PIN
├── ViewModels/
│   ├── AlarmViewModel.swift      # Business logic for managing alarms
│   └── PinViewModel.swift        # Logic for PIN generation and validation
├── Services/
│   ├── AlarmScheduler.swift      # Handles notification and scheduling logic
│   ├── WatchConnectivityService.swift  # iOS ↔ Watch communication
│   └── PinGenerator.swift        # Generates 4-digit random PIN
├── Extensions/
│   └── Date+Utils.swift          # Custom date helpers
├── WatchApp/                     # watchOS target
│   ├── WatchAlarmClockApp.swift # watchOS entry point
│   ├── Views/...
│   └── ViewModels/...
└── Utilities/
    └── Logger.swift              # Central logging utility
```

---

## 3. Component Overview

### Models

- **Alarm.swift**: Stores time, repeat info, and if alarm is active.
- **Pin.swift**: Stores generated PIN and expiration time.

### Views

- SwiftUI-based interfaces for both platforms.
- iOS: Allows setting alarm, entering PIN.
- watchOS: Displays PIN at the alarm time.

### ViewModels

- **AlarmViewModel**: Manages alarms, notifications, toggle enable/disable.
- **PinViewModel**: Handles generation, storage, and validation of PIN codes.

### Services

- **AlarmScheduler**: Uses `UNUserNotificationCenter` to schedule silent notifications.
- **WatchConnectivityService**: Uses `WCSession` to send data between watch and iPhone.
- **PinGenerator**: Central logic for PIN creation, ensuring security and randomness.

---

## 4. State Management

- **Combine framework** used with `@Published` properties in ViewModels.
- State such as alarms and current PIN lives in ViewModels and can be persisted in `UserDefaults` or Keychain for secure storage.

---

## 5. Service Connections

- **iOS ↔ watchOS**

  - Via `WatchConnectivity` to send the PIN at scheduled time.
  - App on watch receives PIN and displays it to the user.

- **PIN Validation**

  - PIN is generated on iOS and sent to the watch.
  - On alarm trigger, watch displays PIN and waits for iPhone user input.
  - Alarm is only dismissed once the correct PIN is entered.

- **Optional Analytics Backend**
  - If included, sends alarm usage, wake-up success, and user events for analytics.

---

## 6. Competitor Landscape

| App Name    | Feature                                 | Notes                         |
| ----------- | --------------------------------------- | ----------------------------- |
| Sleep Cycle | Smart alarm, silent wake, data tracking | No PIN challenge              |
| Alarmy      | Wake-up tasks (e.g. math) to disable    | Loud phone-based alarms       |
| Watch Alarm | Apple Watch vibration-based alarms      | Lacks PIN challenge mechanism |

---

## 7. Additional Notes

### Security

- PINs should be securely generated and expire after a short window.
- Store in Keychain or encrypted `UserDefaults` if persistence is needed.

### Accessibility

- Ensure vibration patterns and font sizes are configurable.

### Testing

- Unit tests: ViewModels, Services
- UI tests: Alarm workflow, PIN entry flow
- Device testing on real iPhone and Apple Watch is required

### Monetization

- Free version with 1 alarm slot
- Premium unlock for multiple alarms or smart features (via In-App Purchase)

### App Store Compliance

- Use silent notifications properly
- Request background task privileges with justification
- Use `App Groups` for shared state if needed

---

## 8. Future Considerations

- Smart alarm logic (wake at lightest sleep)
- Multiple PIN types (math, shake, scan QR)
- Watch complications support
- Alarm history and analytics dashboard

---

## 9. Open Questions

- Should alarms be persistent across reboots?
- Should there be a snooze feature at all?
- Should the watch also have a fallback audible alarm?
