import SwiftUI

struct ButtonView: View {
    @StateObject private var viewModel = ButtonViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // 1. Обычная кнопка
                VStack(alignment: .leading, spacing: 12) {
                    Text("ButtonView.sectionTitle.normalButton")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        viewModel.toggleTapped()
                    }) {
                        Text(viewModel.isTapped ? String(localized: "ButtonView.tapped") : String(localized: "ButtonView.normalButton"))
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
                    
                    Toggle(String(localized: "ButtonView.enableButton"), isOn: $viewModel.isEnabled)
                        .padding(.bottom, 8)
                    
                    Button(action: {
                        // Действие кнопки
                    }) {
                        Text(String(localized: "ButtonView.disabledButton"))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isEnabled ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(!viewModel.isEnabled)
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
                        viewModel.startLoading()
                    }) {
                        HStack(spacing: 8) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else if viewModel.isSuccess {
                                Image(systemName: "checkmark.circle.fill")
                            }
                            
                            Text(viewModel.isSuccess ? String(localized: "ButtonView.success") : String(localized: "ButtonView.loadingButton"))
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(viewModel.isLoading ? Color.blue : (viewModel.isSuccess ? Color.green : Color.blue))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(viewModel.isLoading)
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
    NavigationStack {
        ButtonView()
            .navigationTitle("Button")
    }
}
