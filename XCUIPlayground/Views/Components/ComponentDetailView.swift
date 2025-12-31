import SwiftUI

struct ComponentDetailView: View {
    @StateObject private var viewModel: ComponentDetailViewModel

    init(item: ComponentItem) {
        _viewModel = StateObject(wrappedValue: ComponentDetailViewModel(item: item))
    }
    
    var body: some View {
        Group {
            switch viewModel.kind {
            case .button:
                ButtonView()
            case .inputField:
                InputFieldView()
            case .slider:
                SliderView()
            case .stepper:
                StepperView()
            case .picker:
                PickerView()
            case .toggle:
                ToggleView()
            case .alert:
                AlertView()
            case .modal:
                ModalView()
            case .webView:
                WebViewComponentView()
            case .safariView:
                SafariViewComponentView()
            case .unknown:
                VStack {
                    Text(viewModel.title)
                        .font(.largeTitle)
                        .padding()
                    
                    Text(String(localized: "ComponentDetailView.details"))
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ComponentDetailView(item: ComponentItem(name: "Кнопка", kind: .button))
    }
}
