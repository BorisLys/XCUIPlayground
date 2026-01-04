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
        )
    ]
}
