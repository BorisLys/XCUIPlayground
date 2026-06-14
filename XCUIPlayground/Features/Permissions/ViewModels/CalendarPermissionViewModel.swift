import Combine
import EventKit
import SwiftUI

final class CalendarPermissionViewModel: ObservableObject {
    @Published var authorizationStatus: EKAuthorizationStatus = .notDetermined
    @Published var events: [EKEvent] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage: String = ""

    var isAuthorized: Bool {
        authorizationStatus == .fullAccess || authorizationStatus == .authorized
    }

    private let store = EKEventStore()

    func checkStatus() {
        authorizationStatus = EKEventStore.authorizationStatus(for: .event)
    }

    func requestPermission() {
        store.requestFullAccessToEvents { [weak self] granted, error in
            DispatchQueue.main.async {
                if let error {
                    self?.alertMessage = String(localized: "CalendarPermissionView.errorMessage") + ": \(error.localizedDescription)"
                    self?.showAlert = true
                } else if granted {
                    self?.alertMessage = String(localized: "CalendarPermissionView.successMessage")
                    self?.showAlert = true
                    self?.fetchEvents()
                } else {
                    self?.alertMessage = String(localized: "CalendarPermissionView.deniedMessage")
                    self?.showAlert = true
                }
                self?.checkStatus()
            }
        }
    }

    func fetchEvents() {
        isLoading = true
        let now = Date()
        let future = Calendar.current.date(byAdding: .month, value: 1, to: now) ?? now
        let predicate = store.predicateForEvents(withStart: now, end: future, calendars: nil)
        let fetched = store.events(matching: predicate)
            .sorted { $0.startDate < $1.startDate }
            .prefix(5)
        DispatchQueue.main.async {
            self.events = Array(fetched)
            self.isLoading = false
        }
    }

    func createTestEvent() {
        let event = EKEvent(eventStore: store)
        event.title = String(localized: "CalendarPermissionView.testEventTitle")
        event.startDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        event.endDate = Calendar.current.date(byAdding: .hour, value: 1, to: event.startDate) ?? Date()
        event.calendar = store.defaultCalendarForNewEvents
        do {
            try store.save(event, span: .thisEvent)
            alertMessage = String(localized: "CalendarPermissionView.eventCreated")
            showAlert = true
            fetchEvents()
        } catch {
            alertMessage = String(localized: "CalendarPermissionView.errorMessage") + ": \(error.localizedDescription)"
            showAlert = true
        }
    }

    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
