import SwiftUI
import Combine

final class SliderViewModel: ObservableObject {
    @Published var sliderValue: Double = 50.0
    let minValue: Double = 0.0
    let maxValue: Double = 100.0
}
