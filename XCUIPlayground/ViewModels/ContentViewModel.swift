import SwiftUI
import Combine

final class ContentViewModel: ObservableObject {
    enum Tab: Hashable {
        case components
        case flow
        case permissions
    }

    @Published var selectedTab: Tab = .components
}
