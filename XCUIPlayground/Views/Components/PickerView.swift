import SwiftUI

struct PickerView: View {
    @StateObject private var viewModel = PickerViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // 1. Menu Style Picker
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "PickerView.colorTitle"))
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Picker(String(localized: "PickerView.colorLabel"), selection: $viewModel.selectedColor) {
                        ForEach(viewModel.colors, id: \.self) { color in
                            Text(color).tag(color)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(String(localized: "PickerView.selected") + ": \(viewModel.selectedColor)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // 2. Segmented Style Picker
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "PickerView.sizeTitle"))
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Picker(String(localized: "PickerView.sizeLabel"), selection: $viewModel.selectedSize) {
                        ForEach(viewModel.sizes, id: \.self) { size in
                            Text(size).tag(size)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Text(String(localized: "PickerView.selected") + ": \(viewModel.selectedSize)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // 3. Wheel Style Picker
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "PickerView.wheelTitle"))
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Picker(String(localized: "PickerView.colorLabel"), selection: $viewModel.selectedColor) {
                        ForEach(viewModel.colors, id: \.self) { color in
                            Text(color).tag(color)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 150)
                    
                    Text(String(localized: "PickerView.selected") + ": \(viewModel.selectedColor)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // 4. Date Picker
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "PickerView.dateTitle"))
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    DatePicker(
                        String(localized: "PickerView.dateLabel"),
                        selection: $viewModel.selectedDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                    
                    Text(String(localized: "PickerView.selectedDate") + ": \(viewModel.formatDate(viewModel.selectedDate))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding()
        }
    }
    
}

#Preview {
    NavigationView {
        PickerView()
            .navigationTitle("Picker")
    }
}
