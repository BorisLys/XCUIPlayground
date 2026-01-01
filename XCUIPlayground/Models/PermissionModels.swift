import SwiftUI

struct PermissionItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let systemImage: String
    let color: Color
    let kind: PermissionKind
}

enum PermissionKind: Hashable {
    case photo
    case notifications
    case contacts
    case location
}
