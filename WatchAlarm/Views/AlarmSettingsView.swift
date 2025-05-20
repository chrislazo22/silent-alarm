import SwiftUI

struct AlarmSettingsView: View {
    @Binding var time: Date
    @Binding var isRepeating: Bool
    @Binding var repeatDays: Set<Alarm.Weekday>
    
    @State private var showingRepeatDays = false
    
    var body: some View {
        Form {
            Section {
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical)
            }
            
            Section {
                Toggle("Repeat", isOn: $isRepeating)
                
                if isRepeating {
                    Button(action: { showingRepeatDays.toggle() }) {
                        HStack {
                            Text("Repeat Days")
                            Spacer()
                            Text(repeatDaysText)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingRepeatDays) {
            RepeatDaysView(selectedDays: $repeatDays)
        }
    }
    
    private var repeatDaysText: String {
        if repeatDays.isEmpty {
            return "Never"
        } else if repeatDays.count == 7 {
            return "Every day"
        } else if repeatDays.count == 5 && 
                  repeatDays.contains(.monday) &&
                  repeatDays.contains(.tuesday) &&
                  repeatDays.contains(.wednesday) &&
                  repeatDays.contains(.thursday) &&
                  repeatDays.contains(.friday) {
            return "Weekdays"
        } else if repeatDays.count == 2 &&
                  repeatDays.contains(.saturday) &&
                  repeatDays.contains(.sunday) {
            return "Weekends"
        } else {
            return repeatDays.sorted { $0.rawValue < $1.rawValue }
                .map { $0.shortName }
                .joined(separator: ", ")
        }
    }
}

// MARK: - Repeat Days Selection View
private struct RepeatDaysView: View {
    @Binding var selectedDays: Set<Alarm.Weekday>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(Alarm.Weekday.allCases, id: \.self) { day in
                Button(action: { toggleDay(day) }) {
                    HStack {
                        Text(day.shortName)
                        Spacer()
                        if selectedDays.contains(day) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
            .navigationTitle("Repeat Days")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func toggleDay(_ day: Alarm.Weekday) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }
}

#Preview {
    AlarmSettingsView(
        time: .constant(Date()),
        isRepeating: .constant(true),
        repeatDays: .constant([.monday, .wednesday, .friday])
    )
} 
