import SwiftUI

struct SliderView: View {
    @StateObject private var viewModel = SliderViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Слайдер
            VStack(spacing: 20) {
                Text(String(localized: "SliderView.title"))
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Slider(
                    value: $viewModel.sliderValue,
                    in: viewModel.minValue...viewModel.maxValue,
                    step: 1.0
                ) {
                    Text(String(localized: "SliderView.sliderLabel"))
                } minimumValueLabel: {
                    Text("\(Int(viewModel.minValue))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } maximumValueLabel: {
                    Text("\(Int(viewModel.maxValue))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // Отображение значения в реальном времени
            VStack(spacing: 12) {
                Text(String(localized: "SliderView.currentValue"))
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("\(Int(viewModel.sliderValue))")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.blue)
                    .padding()
                    .frame(minWidth: 120)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.3))
            .cornerRadius(12)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    NavigationView {
        SliderView()
            .navigationTitle("Slider")
    }
}
