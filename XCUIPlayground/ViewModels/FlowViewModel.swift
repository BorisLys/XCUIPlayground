import SwiftUI
import Combine

struct FlowItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let kind: FlowKind
}

enum FlowKind: Hashable {
    case biometricAuth
}

final class FlowViewModel: ObservableObject {
    let title = String(localized: "FlowView.title")

    let items: [FlowItem] = [
        FlowItem(
            title: String(localized: "FlowView.biometricTitle"),
            subtitle: String(localized: "FlowView.biometricSubtitle"),
            kind: .biometricAuth
        )
    ]
}
