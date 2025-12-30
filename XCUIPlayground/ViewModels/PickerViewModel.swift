import SwiftUI
import Combine

final class PickerViewModel: ObservableObject {
    @Published var selectedColor: String = "Red"
    let colors = ["Red", "Green", "Blue", "Yellow", "Purple"]

    @Published var selectedSize: String = "Small"
    let sizes = ["Small", "Medium", "Large", "Extra Large"]

    @Published var selectedDate: Date = Date()

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
