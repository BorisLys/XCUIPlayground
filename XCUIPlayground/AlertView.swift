import SwiftUI

struct AlertView: View {
    @State private var showBasicAlert = false
    @State private var showTwoButtonAlert = false
    @State private var showDestructiveAlert = false
    @State private var showTextFieldAlert = false
    @State private var alertText: String = ""
    @State private var showToast = false
    @State private var toastMessage: String = ""
    
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
                        showBasicAlert = true
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
                .alert(String(localized: "AlertView.basicAlertTitle"), isPresented: $showBasicAlert) {
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
                        showTwoButtonAlert = true
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
                .alert(String(localized: "AlertView.twoButtonAlertTitle"), isPresented: $showTwoButtonAlert) {
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
                        showDestructiveAlert = true
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
                .alert(String(localized: "AlertView.destructiveAlertTitle"), isPresented: $showDestructiveAlert) {
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
                        showTextFieldAlert = true
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
                .alert(String(localized: "AlertView.textFieldAlertTitle"), isPresented: $showTextFieldAlert) {
                    TextField(String(localized: "AlertView.textFieldPlaceholder"), text: $alertText)
                    Button(String(localized: "AlertView.cancel"), role: .cancel) {
                        alertText = ""
                    }
                    Button(String(localized: "AlertView.save")) {
                        if !alertText.isEmpty {
                            toastMessage = alertText
                            showToast = true
                            // Автоматически скрыть через 3 секунды
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                showToast = false
                            }
                        }
                        alertText = ""
                    }
                } message: {
                    Text(String(localized: "AlertView.textFieldAlertMessage"))
                }
                }
                .padding()
            }
            
            // Всплывающее сообщение (toast)
            if showToast {
                VStack {
                    Spacer()
                    HStack {
                        Text(toastMessage)
                            .font(.body)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(12)
                    .padding()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .animation(.easeInOut, value: showToast)
            }
        }
    }
}

#Preview {
    NavigationView {
        AlertView()
            .navigationTitle("Alert")
    }
}

