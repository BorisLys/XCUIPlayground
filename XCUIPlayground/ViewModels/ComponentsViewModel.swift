import SwiftUI
import Combine

struct ComponentItem: Hashable, Identifiable {
    let name: String
    let kind: ComponentKind

    var id: String { name }
}

enum ComponentKind: Hashable {
    case button
    case inputField
    case slider
    case stepper
    case picker
    case toggle
    case alert
    case modal
    case unknown
}

final class ComponentsViewModel: ObservableObject {
    let items: [ComponentItem]

    init() {
        items = [
            ComponentItem(name: String(localized: "ComponentsView.button"), kind: .button),
            ComponentItem(name: String(localized: "ComponentsView.inputField"), kind: .inputField),
            ComponentItem(name: String(localized: "ComponentsView.slider"), kind: .slider),
            ComponentItem(name: String(localized: "ComponentsView.stepper"), kind: .stepper),
            ComponentItem(name: String(localized: "ComponentsView.picker"), kind: .picker),
            ComponentItem(name: String(localized: "ComponentsView.toggle"), kind: .toggle),
            ComponentItem(name: String(localized: "ComponentsView.alert"), kind: .alert),
            ComponentItem(name: String(localized: "ComponentsView.modal"), kind: .modal)
        ]
    }
}
