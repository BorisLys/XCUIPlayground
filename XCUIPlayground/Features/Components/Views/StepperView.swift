import SwiftUI

struct StepperView: View {
    @StateObject private var viewModel = StepperViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(alignment: .leading, spacing: 12) {
                Text(String(localized: "StepperView.quantityTitle"))
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Text(String(localized: "StepperView.quantityLabel"))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Stepper(
                        value: $viewModel.quantity,
                        in: viewModel.minValue...viewModel.maxValue,
                        step: 1
                    ) {
                        Text("\(viewModel.quantity)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(minWidth: 50)
                    }
                }
                
                Text(String(localized: "StepperView.range") + ": \(viewModel.minValue) - \(viewModel.maxValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        StepperView()
            .navigationTitle("Stepper")
    }
}
