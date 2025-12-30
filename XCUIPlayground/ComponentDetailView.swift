import SwiftUI

struct ComponentDetailView: View {
    let componentName: String
    
    var body: some View {
        Group {
            if componentName == String(localized: "ComponentsView.button") {
                ButtonView()
            } else if componentName == String(localized: "ComponentsView.inputField") {
                InputFieldView()
            } else if componentName == String(localized: "ComponentsView.slider") {
                SliderView()
            } else if componentName == String(localized: "ComponentsView.stepper") {
                StepperView()
            } else if componentName == String(localized: "ComponentsView.picker") {
                PickerView()
            } else if componentName == String(localized: "ComponentsView.toggle") {
                ToggleView()
            } else if componentName == String(localized: "ComponentsView.alert") {
                AlertView()
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
