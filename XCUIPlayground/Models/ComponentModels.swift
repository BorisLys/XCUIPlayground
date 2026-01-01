import Foundation

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
