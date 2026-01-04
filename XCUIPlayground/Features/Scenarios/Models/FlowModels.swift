import Foundation

struct FlowItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let kind: FlowKind
}

enum FlowKind: Hashable {
    case biometricAuth
}
