import SwiftUI
import Combine

final class StepperViewModel: ObservableObject {
    @Published var quantity: Int = 1
    let minValue: Int = 1
    let maxValue: Int = 10
}
