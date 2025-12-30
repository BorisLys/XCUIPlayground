import SwiftUI
import Combine

final class ButtonViewModel: ObservableObject {
    @Published var isTapped = false
    @Published var isEnabled = false
    @Published var isLoading = false
    @Published var isSuccess = false

    func toggleTapped() {
        isTapped.toggle()
    }

    func startLoading() {
        isLoading = true
        isSuccess = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            guard let self else { return }
            self.isLoading = false
            self.isSuccess = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.isSuccess = false
            }
        }
    }
}
