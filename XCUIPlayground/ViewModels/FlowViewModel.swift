import SwiftUI
import Combine

final class FlowViewModel: ObservableObject {
    let title = String(localized: "FlowView.title")
    let descriptionText = String(localized: "FlowView.description")
}
