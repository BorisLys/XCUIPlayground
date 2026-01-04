import SwiftUI

struct AlertView: View {
    @StateObject private var viewModel = AlertViewModel()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                // 1. Базовый алерт с одной кнопкой
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "AlertView.basicTitle"))
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        viewModel.showBasicAlert = true
                    }) {
                        Text(String(localized: "AlertView.showBasicAlert"))
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
                .alert(String(localized: "AlertView.basicAlertTitle"), isPresented: $viewModel.showBasicAlert) {
                    Button(String(localized: "AlertView.ok"), role: .cancel) { }
                } message: {
                    Text(String(localized: "AlertView.basicAlertMessage"))
                }
                
                // 2. Алерт с двумя кнопками
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "AlertView.twoButtonTitle"))
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        viewModel.showTwoButtonAlert = true
                    }) {
                        Text(String(localized: "AlertView.showTwoButtonAlert"))
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
                .alert(String(localized: "AlertView.twoButtonAlertTitle"), isPresented: $viewModel.showTwoButtonAlert) {
                    Button(String(localized: "AlertView.cancel"), role: .cancel) { }
                    Button(String(localized: "AlertView.confirm")) { }
                } message: {
                    Text(String(localized: "AlertView.twoButtonAlertMessage"))
                }
                
                // 3. Деструктивный алерт
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "AlertView.destructiveTitle"))
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        viewModel.showDestructiveAlert = true
                    }) {
                        Text(String(localized: "AlertView.showDestructiveAlert"))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .alert(String(localized: "AlertView.destructiveAlertTitle"), isPresented: $viewModel.showDestructiveAlert) {
                    Button(String(localized: "AlertView.cancel"), role: .cancel) { }
                    Button(String(localized: "AlertView.delete"), role: .destructive) { }
                } message: {
                    Text(String(localized: "AlertView.destructiveAlertMessage"))
                }
                
                // 4. Алерт с текстовым полем
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "AlertView.textFieldTitle"))
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        viewModel.showTextFieldAlert = true
                    }) {
                        Text(String(localized: "AlertView.showTextFieldAlert"))
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
                .alert(String(localized: "AlertView.textFieldAlertTitle"), isPresented: $viewModel.showTextFieldAlert) {
                    TextField(String(localized: "AlertView.textFieldPlaceholder"), text: $viewModel.alertText)
                    Button(String(localized: "AlertView.cancel"), role: .cancel) {
                        viewModel.resetTextField()
                    }
                    Button(String(localized: "AlertView.save")) {
                        viewModel.showTextFieldSavedToast()
                    }
                } message: {
                    Text(String(localized: "AlertView.textFieldAlertMessage"))
                }
                }
                .padding()
            }
            
            // Всплывающее сообщение (toast)
            if viewModel.showToast {
                VStack {
                    Spacer()
                    HStack {
                        Text(viewModel.toastMessage)
                            .font(.body)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(12)
                    .padding()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .animation(.easeInOut, value: viewModel.showToast)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AlertView()
            .navigationTitle("Alert")
    }
}
