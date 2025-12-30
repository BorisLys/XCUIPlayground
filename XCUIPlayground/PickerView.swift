import SwiftUI

struct PickerView: View {
    @State private var selectedColor: String = "Red"
    let colors = ["Red", "Green", "Blue", "Yellow", "Purple"]
    
    @State private var selectedSize: String = "Small"
    let sizes = ["Small", "Medium", "Large", "Extra Large"]
    
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // 1. Menu Style Picker
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "PickerView.colorTitle"))
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Picker(String(localized: "PickerView.colorLabel"), selection: $selectedColor) {
                        ForEach(colors, id: \.self) { color in
                            Text(color).tag(color)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(String(localized: "PickerView.selected") + ": \(selectedColor)")
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
                    
                    Picker(String(localized: "PickerView.sizeLabel"), selection: $selectedSize) {
                        ForEach(sizes, id: \.self) { size in
                            Text(size).tag(size)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Text(String(localized: "PickerView.selected") + ": \(selectedSize)")
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
                    
                    Picker(String(localized: "PickerView.colorLabel"), selection: $selectedColor) {
                        ForEach(colors, id: \.self) { color in
                            Text(color).tag(color)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 150)
                    
                    Text(String(localized: "PickerView.selected") + ": \(selectedColor)")
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
                        selection: $selectedDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                    
                    Text(String(localized: "PickerView.selectedDate") + ": \(formatDate(selectedDate))")
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
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationView {
        PickerView()
            .navigationTitle("Picker")
    }
}

