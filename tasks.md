
# MVP Build Plan for Alarm Clock App

Each task below is intentionally granular and testable. Every task has a well-defined beginning and end, and should result in either a visible UI element or a tested piece of logic. This plan assumes you're using Swift + SwiftUI, and testing with XCTest and UI testing.

---

## 1. Project Setup

### Task 1.1: Create new Xcode project with iOS and watchOS targets
- **Start:** Open Xcode and create a new iOS app with SwiftUI lifecycle.
- **End:** Confirm iOS and watchOS targets exist and can run in simulators.

### Task 1.2: Create shared `Alarm` model
- **Start:** Create `Alarm.swift` under `Models/`.
- **End:** Define struct with fields: `id`, `time`, `isEnabled`, `repeatDays`.

---

## 2. Alarm Setting UI (iOS)

### Task 2.1: Create `AlarmSettingsView.swift`
- **Start:** Create new SwiftUI view.
- **End:** Display a `DatePicker` and toggle for repeat.

### Task 2.2: Create `AlarmViewModel.swift`
- **Start:** Create ViewModel with `@Published var alarm: Alarm`.
- **End:** Bind view state to `AlarmSettingsView`.

### Task 2.3: Add button to save alarm
- **Start:** Add “Save Alarm” button to view.
- **End:** Tapping button triggers ViewModel to store alarm in `UserDefaults`.

### Task 2.4: Write unit test for saving alarm
- **Start:** Create test target if not already set up.
- **End:** Test that `AlarmViewModel.save()` writes correct value to storage.

---

## 3. Local Notifications (iOS)

### Task 3.1: Request notification permissions
- **Start:** Add request call in app launch.
- **End:** System prompt appears on first launch.

### Task 3.2: Create `AlarmScheduler.swift`
- **Start:** Create service under `Services/`.
- **End:** Implement function to schedule silent notification at alarm time.

### Task 3.3: Write test for `AlarmScheduler`
- **Start:** Mock UNUserNotificationCenter.
- **End:** Assert correct notification is created.

---

## 4. Random PIN Generation (iOS)

### Task 4.1: Create `PinGenerator.swift`
- **Start:** Create service under `Services/`.
- **End:** Method returns random 4-digit string.

### Task 4.2: Write test for `PinGenerator`
- **Start:** Write test with 100 iterations.
- **End:** Assert all results are 4-digit numeric strings.

---

## 5. Watch Communication

### Task 5.1: Setup `WatchConnectivityService.swift`
- **Start:** Create service under `Services/`.
- **End:** Implement sending PIN from iOS to watch.

### Task 5.2: Test sending static data to watch
- **Start:** Trigger send in ViewModel or test harness.
- **End:** Confirm message is received in watchOS log.

---

## 6. Display PIN on Apple Watch

### Task 6.1: Create `WatchPinView.swift`
- **Start:** SwiftUI view on watch target.
- **End:** Static text displays passed-in PIN.

### Task 6.2: Bind WatchPinView to received data
- **Start:** Receive PIN via `WCSession`.
- **End:** PIN updates on-screen when received.

### Task 6.3: Write UI test to simulate PIN display
- **Start:** Write watchOS UI test.
- **End:** Assert that label displays correct PIN.

---

## 7. Disable Alarm via PIN on iPhone

### Task 7.1: Create `PinInputView.swift`
- **Start:** iOS View to enter PIN.
- **End:** Accepts 4-digit input and submits.

### Task 7.2: Create `PinViewModel.swift`
- **Start:** Holds correct PIN and input PIN.
- **End:** `isValid()` returns true if match.

### Task 7.3: Write test for PIN match
- **Start:** Unit test for `PinViewModel`.
- **End:** Valid and invalid PINs tested.

### Task 7.4: Disable alarm on match
- **Start:** In ViewModel, observe input PIN.
- **End:** On correct match, cancel local notification.

---

## 8. MVP Verification

### Task 8.1: End-to-end test: set alarm and disable via PIN
- **Start:** Manual or automated test.
- **End:** Confirm watch vibrates, shows PIN, and PIN disables alarm.

---

## 9. Optional Polish Tasks

### Task 9.1: Store last alarm fired in UserDefaults
### Task 9.2: Add haptics/vibration patterns to Apple Watch
### Task 9.3: UI polish: font scaling and contrast

---

## 10. Next Steps After MVP

- Add In-App Purchases via StoreKit 2
- Support recurring alarms
- Add analytics (e.g. Firebase or App Store Analytics)
- Support iCloud syncing if multi-device use is needed
