import SwiftUI

struct ModalView: View {
    @StateObject private var viewModel = ModalViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "ModalView.sheetTitle"))
                        .font(.headline)
                        .foregroundColor(.primary)

                    Button(action: {
                        viewModel.openSheet()
                    }) {
                        Text(String(localized: "ModalView.sheetButton"))
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

                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "ModalView.fullscreenTitle"))
                        .font(.headline)
                        .foregroundColor(.primary)

                    Button(action: {
                        viewModel.openFullScreen()
                    }) {
                        Text(String(localized: "ModalView.fullscreenButton"))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding()
        }
        .sheet(isPresented: $viewModel.showSheet) {
            ModalContentView(
                title: String(localized: "ModalView.sheetModalTitle"),
                message: String(localized: "ModalView.sheetModalMessage"),
                buttonTitle: String(localized: "ModalView.close")
            ) {
                viewModel.closeSheet()
            }
        }
        .fullScreenCover(isPresented: $viewModel.showFullScreen) {
            ModalContentView(
                title: String(localized: "ModalView.fullscreenModalTitle"),
                message: String(localized: "ModalView.fullscreenModalMessage"),
                buttonTitle: String(localized: "ModalView.close")
            ) {
                viewModel.closeFullScreen()
            }
        }
    }
}

private struct ModalContentView: View {
    let title: String
    let message: String
    let buttonTitle: String
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            VStack(spacing: 12) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()

            Button(action: {
                onClose()
            }) {
                Text(buttonTitle)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    NavigationView {
        ModalView()
            .navigationTitle("Modal")
    }
}
