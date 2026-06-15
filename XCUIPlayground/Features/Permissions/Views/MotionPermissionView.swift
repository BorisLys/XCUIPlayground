import SwiftUI

struct MotionPermissionView: View {
    @StateObject private var viewModel = MotionPermissionViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if !viewModel.isAuthorized {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "MotionPermissionView.requestTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(String(localized: "MotionPermissionView.requestDescription"))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Button {
                            viewModel.requestAndFetchSteps()
                        } label: {
                            Text(String(localized: "MotionPermissionView.requestButton"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.isDenied ? Color.gray : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.isDenied)
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
                }

                if viewModel.isDenied {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "MotionPermissionView.settingsTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        Button {
                            viewModel.openSettings()
                        } label: {
                            Text(String(localized: "MotionPermissionView.settingsButton"))
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
                        Text(String(localized: "MotionPermissionView.stepsTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)

                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            HStack(spacing: 12) {
                                Image(systemName: "figure.walk")
                                    .foregroundColor(.purple)
                                    .font(.title2)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(String(localized: "MotionPermissionView.stepsToday"))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(viewModel.stepCount.map { "\($0)" } ?? "—")
                                        .font(.title2.bold())
                                        .foregroundColor(.primary)
                                }
                                Spacer()
                            }
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)

                            Button {
                                viewModel.requestAndFetchSteps()
                            } label: {
                                Text(String(localized: "MotionPermissionView.refreshButton"))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.purple)
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
        .navigationTitle(String(localized: "MotionPermissionView.title"))
        .onAppear {
            viewModel.checkStatus()
        }
        .alert(String(localized: "MotionPermissionView.alertTitle"), isPresented: $viewModel.showAlert) {
            Button(String(localized: "AlertView.ok"), role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    NavigationStack {
        MotionPermissionView()
    }
}
