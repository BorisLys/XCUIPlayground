import Combine
import EventKit
import SwiftUI

final class RemindersPermissionViewModel: ObservableObject {
    @Published var authorizationStatus: EKAuthorizationStatus = .notDetermined
    @Published var reminders: [EKReminder] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage: String = ""

    var isAuthorized: Bool {
        authorizationStatus == .fullAccess || authorizationStatus == .authorized
    }

    private let store = EKEventStore()

    func checkStatus() {
        authorizationStatus = EKEventStore.authorizationStatus(for: .reminder)
    }

    func requestPermission() {
        store.requestFullAccessToReminders { [weak self] granted, error in
            DispatchQueue.main.async {
                if let error {
                    self?.alertMessage = String(localized: "RemindersPermissionView.errorMessage") + ": \(error.localizedDescription)"
                    self?.showAlert = true
                } else if granted {
                    self?.alertMessage = String(localized: "RemindersPermissionView.successMessage")
                    self?.showAlert = true
                    self?.fetchReminders()
                } else {
                    self?.alertMessage = String(localized: "RemindersPermissionView.deniedMessage")
                    self?.showAlert = true
                }
                self?.checkStatus()
            }
        }
    }

    func fetchReminders() {
        isLoading = true
        let predicate = store.predicateForIncompleteReminders(withDueDateStarting: nil, ending: nil, calendars: nil)
        store.fetchReminders(matching: predicate) { [weak self] fetched in
            DispatchQueue.main.async {
                self?.reminders = (fetched ?? []).sorted { ($0.dueDateComponents?.date ?? Date()) < ($1.dueDateComponents?.date ?? Date()) }
                self?.isLoading = false
            }
        }
    }

    func createTestReminder() {
        let reminder = EKReminder(eventStore: store)
        reminder.title = String(localized: "RemindersPermissionView.testReminderTitle")
        reminder.calendar = store.defaultCalendarForNewReminders()
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        components.hour = (components.hour ?? 0) + 1
        reminder.dueDateComponents = components
        do {
            try store.save(reminder, commit: true)
            alertMessage = String(localized: "RemindersPermissionView.reminderCreated")
            showAlert = true
            fetchReminders()
        } catch {
            alertMessage = String(localized: "RemindersPermissionView.errorMessage") + ": \(error.localizedDescription)"
            showAlert = true
        }
    }

    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
