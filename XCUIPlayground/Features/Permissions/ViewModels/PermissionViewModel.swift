import SwiftUI
import Combine

final class PermissionViewModel: ObservableObject {
    let items: [PermissionItem] = [
        PermissionItem(
            title: String(localized: "PermissionView.photoCell"),
            systemImage: "photo",
            color: .blue,
            kind: .photo
        ),
        PermissionItem(
            title: String(localized: "PermissionView.notificationCell"),
            systemImage: "bell",
            color: .orange,
            kind: .notifications
        ),
        PermissionItem(
            title: String(localized: "PermissionView.contactsCell"),
            systemImage: "person.crop.circle",
            color: .teal,
            kind: .contacts
        ),
        PermissionItem(
            title: String(localized: "PermissionView.locationCell"),
            systemImage: "location",
            color: .green,
            kind: .location
        ),
        PermissionItem(
            title: String(localized: "PermissionView.microphoneCell"),
            systemImage: "mic",
            color: .pink,
            kind: .microphone
        ),
        PermissionItem(
            title: String(localized: "PermissionView.calendarCell"),
            systemImage: "calendar",
            color: .blue,
            kind: .calendar
        ),
        PermissionItem(
            title: String(localized: "PermissionView.remindersCell"),
            systemImage: "checklist",
            color: .orange,
            kind: .reminders
        ),
        PermissionItem(
            title: String(localized: "PermissionView.motionCell"),
            systemImage: "figure.walk",
            color: .purple,
            kind: .motion
        ),
        PermissionItem(
            title: String(localized: "PermissionView.trackingCell"),
            systemImage: "app.badge.checkmark",
            color: .indigo,
            kind: .tracking
        )
    ]
}
