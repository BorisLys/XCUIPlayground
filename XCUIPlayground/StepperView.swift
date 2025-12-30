import SwiftUI

struct StepperView: View {
    @State private var quantity: Int = 1
    @State private var minValue: Int = 1
    @State private var maxValue: Int = 10
    
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
                        value: $quantity,
                        in: minValue...maxValue,
                        step: 1
                    ) {
                        Text("\(quantity)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(minWidth: 50)
                    }
                }
                
                Text(String(localized: "StepperView.range") + ": \(minValue) - \(maxValue)")
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
    NavigationView {
        StepperView()
            .navigationTitle("Stepper")
    }
}

