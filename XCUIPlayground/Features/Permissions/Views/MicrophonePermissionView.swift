import SwiftUI

struct MicrophonePermissionView: View {
    @StateObject private var viewModel = MicrophonePermissionViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if !viewModel.isAuthorized {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "MicrophonePermissionView.requestTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        Button {
                            viewModel.requestPermission()
                        } label: {
                            Text(String(localized: "MicrophonePermissionView.requestButton"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    viewModel.authorizationStatus == .denied || viewModel.authorizationStatus == .restricted
                                        ? Color.gray : Color.blue
                                )
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.authorizationStatus == .denied || viewModel.authorizationStatus == .restricted)
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
                }

                if viewModel.authorizationStatus == .denied || viewModel.authorizationStatus == .restricted {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "MicrophonePermissionView.settingsTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        Button {
                            viewModel.openSettings()
                        } label: {
                            Text(String(localized: "MicrophonePermissionView.settingsButton"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
                }

                if viewModel.isAuthorized {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "MicrophonePermissionView.recordTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)

                        Button {
                            if viewModel.isRecording {
                                viewModel.stopRecording()
                            } else {
                                viewModel.startRecording()
                            }
                        } label: {
                            Text(viewModel.isRecording
                                 ? String(localized: "MicrophonePermissionView.stopButton")
                                 : String(localized: "MicrophonePermissionView.recordButton"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.isRecording ? Color.red : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        if viewModel.hasRecording {
                            Button {
                                viewModel.playRecording()
                            } label: {
                                Text(String(localized: "MicrophonePermissionView.playButton"))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle(String(localized: "MicrophonePermissionView.title"))
        .onAppear {
            viewModel.checkStatus()
        }
        .alert(String(localized: "MicrophonePermissionView.alertTitle"), isPresented: $viewModel.showAlert) {
            Button(String(localized: "AlertView.ok"), role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    NavigationStack {
        MicrophonePermissionView()
    }
}
