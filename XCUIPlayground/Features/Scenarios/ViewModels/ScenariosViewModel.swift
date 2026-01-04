import SwiftUI
import Combine

final class ScenariosViewModel: ObservableObject {
    let title = String(localized: "FlowView.title")

    let items: [FlowItem] = [
        FlowItem(
            title: String(localized: "FlowView.biometricTitle"),
            subtitle: String(localized: "FlowView.biometricSubtitle"),
            kind: .biometricAuth
        )
    ]
}
