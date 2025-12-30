import SwiftUI

struct ComponentDetailView: View {
    let componentName: String
    
    var body: some View {
        Group {
            if componentName == String(localized: "ComponentsView.button") {
                ButtonView()
            } else {
                VStack {
                    Text(componentName)
                        .font(.largeTitle)
                        .padding()
                    
                    Text(String(localized: "ComponentDetailView.details"))
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle(componentName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ComponentDetailView(componentName: "Кнопка")
    }
}
