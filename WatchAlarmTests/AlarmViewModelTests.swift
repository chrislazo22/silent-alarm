import XCTest
@testable import WatchAlarm

@MainActor
final class AlarmViewModelTests: XCTestCase {
    var viewModel: AlarmViewModel!
    let testUserDefaults = UserDefaults(suiteName: #file)!
    
    override func setUp() async throws {
        try await super.setUp()
        viewModel = AlarmViewModel(userDefaults: testUserDefaults)
        testUserDefaults.removePersistentDomain(forName: #file)
    }
    
    override func tearDown() async throws {
        viewModel = nil
        testUserDefaults.removePersistentDomain(forName: #file)
        try await super.tearDown()
    }
    
    func testCreateAlarm() async {
        let time = Date()
        let isRepeating = true
        let repeatDays: Set<Alarm.Weekday> = [.monday, .wednesday, .friday]
        
        viewModel.createAlarm(time: time, isRepeating: isRepeating, repeatDays: repeatDays)
        
        XCTAssertEqual(viewModel.alarms.count, 1)
        let savedAlarm = viewModel.alarms[0]
        XCTAssertEqual(savedAlarm.time, time)
        XCTAssertTrue(savedAlarm.isEnabled)
        XCTAssertEqual(savedAlarm.repeatDays, repeatDays)
    }
    
    func testSaveAndLoadAlarms() async {
        let time1 = Date()
        let time2 = Date().addingTimeInterval(3600)
        let repeatDays: Set<Alarm.Weekday> = [.monday, .wednesday, .friday]
        
        viewModel.createAlarm(time: time1, isRepeating: true, repeatDays: repeatDays)
        viewModel.createAlarm(time: time2, isRepeating: false, repeatDays: [])
        
        let newViewModel = AlarmViewModel(userDefaults: testUserDefaults)
        
        XCTAssertEqual(newViewModel.alarms.count, 2)
        XCTAssertEqual(newViewModel.alarms[0].time, time1)
        XCTAssertEqual(newViewModel.alarms[0].repeatDays, repeatDays)
        XCTAssertEqual(newViewModel.alarms[1].time, time2)
        XCTAssertTrue(newViewModel.alarms[1].repeatDays.isEmpty)
    }
    
    func testUpdateAlarm() async {
        let originalTime = Date()
        let updatedTime = Date().addingTimeInterval(3600)
        let repeatDays: Set<Alarm.Weekday> = [.monday, .wednesday, .friday]
        
        viewModel.createAlarm(time: originalTime, isRepeating: false, repeatDays: [])
        let alarm = viewModel.alarms[0]
        var updatedAlarm = alarm
        updatedAlarm.time = updatedTime
        updatedAlarm.repeatDays = repeatDays
        viewModel.updateAlarm(updatedAlarm)
        
        XCTAssertEqual(viewModel.alarms.count, 1)
        XCTAssertEqual(viewModel.alarms[0].time, updatedTime)
        XCTAssertEqual(viewModel.alarms[0].repeatDays, repeatDays)
    }
    
    func testDeleteAlarm() async {
        let time = Date()
        let repeatDays: Set<Alarm.Weekday> = [.monday, .wednesday, .friday]
        
        viewModel.createAlarm(time: time, isRepeating: true, repeatDays: repeatDays)
        let alarm = viewModel.alarms[0]
        viewModel.deleteAlarm(alarm)
        
        XCTAssertTrue(viewModel.alarms.isEmpty)
    }
    
    func testToggleAlarm() async {
        let time = Date()
        
        viewModel.createAlarm(time: time, isRepeating: false, repeatDays: [])
        let alarm = viewModel.alarms[0]
        viewModel.toggleAlarm(alarm)
        
        XCTAssertFalse(viewModel.alarms[0].isEnabled)
        viewModel.toggleAlarm(viewModel.alarms[0])
        XCTAssertTrue(viewModel.alarms[0].isEnabled)
    }
} 