import SwiftUI
import Combine
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
    case webView
    case safariView
    case unknown
}

final class ComponentsViewModel: ObservableObject {
    @Published var searchText: String = ""
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
            ComponentItem(name: String(localized: "ComponentsView.modal"), kind: .modal),
            ComponentItem(name: String(localized: "ComponentsView.webView"), kind: .webView),
            ComponentItem(name: String(localized: "ComponentsView.safariView"), kind: .safariView)
        ]
    }

    var filteredItems: [ComponentItem] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if query.isEmpty {
            return items
        }

        return items.filter { item in
            item.name.localizedCaseInsensitiveContains(query)
        }
    }
}
