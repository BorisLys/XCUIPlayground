import SwiftUI

struct ButtonView: View {
    @State private var isTapped = false
    @State private var isEnabled = false
    @State private var isLoading = false
    @State private var isSuccess = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // 1. Обычная кнопка
                VStack(alignment: .leading, spacing: 12) {
                    Text("ButtonView.sectionTitle.normalButton")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        isTapped.toggle()
                    }) {
                        Text(isTapped ? String(localized: "ButtonView.tapped") : String(localized: "ButtonView.normalButton"))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // 2. Disabled кнопка
                VStack(alignment: .leading, spacing: 12) {
                    Text("ButtonView.sectionTitle.disabledButton")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Toggle(String(localized: "ButtonView.enableButton"), isOn: $isEnabled)
                        .padding(.bottom, 8)
                    
                    Button(action: {
                        // Действие кнопки
                    }) {
                        Text(String(localized: "ButtonView.disabledButton"))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isEnabled ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(!isEnabled)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // 3. Кнопка с loading
                VStack(alignment: .leading, spacing: 12) {
                    Text("ButtonView.sectionTitle.loadingButton")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        isLoading = true
                        isSuccess = false
                        
                        // Симуляция загрузки через 2-3 секунды
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            isLoading = false
                            isSuccess = true
                            
                            // Сброс success через 2 секунды
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isSuccess = false
                            }
                        }
                    }) {
                        HStack(spacing: 8) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else if isSuccess {
                                Image(systemName: "checkmark.circle.fill")
                            }
                            
                            Text(isSuccess ? String(localized: "ButtonView.success") : String(localized: "ButtonView.loadingButton"))
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(isLoading ? Color.blue : (isSuccess ? Color.green : Color.blue))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(isLoading)
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
        ButtonView()
            .navigationTitle("Button")
    }
}

