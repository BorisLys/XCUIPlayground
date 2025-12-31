import SwiftUI
import Combine

final class ModalViewModel: ObservableObject {
    @Published var showSheet = false
    @Published var showFullScreen = false

    func openSheet() {
        showSheet = true
    }

    func openFullScreen() {
        showFullScreen = true
    }

    func closeSheet() {
        showSheet = false
    }

    func closeFullScreen() {
        showFullScreen = false
    }
}
