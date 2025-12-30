import SwiftUI
import Combine

final class ComponentDetailViewModel: ObservableObject {
    let item: ComponentItem

    init(item: ComponentItem) {
        self.item = item
    }

    var title: String {
        item.name
    }

    var kind: ComponentKind {
        item.kind
    }
}
