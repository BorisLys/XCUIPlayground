import SwiftUI
import PhotosUI
import Photos

struct PhotoPermissionView: View {
    @StateObject private var viewModel = PhotoPermissionViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Кнопка запроса разрешения
                if viewModel.photoStatus != .authorized && viewModel.photoStatus != .limited {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "PhotoPermissionView.requestTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Button(action: {
                            viewModel.requestPhotoPermission()
                        }) {
                            Text(String(localized: "PhotoPermissionView.requestButton"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.photoStatus == .denied ? Color.gray : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.photoStatus == .denied)
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
                }
                
                // Кнопка открытия настроек
                if viewModel.photoStatus == .denied {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "PhotoPermissionView.settingsTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Button(action: {
                            viewModel.openSettings()
                        }) {
                            Text(String(localized: "PhotoPermissionView.settingsButton"))
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
                
                // Выбор фото
                if viewModel.photoStatus == .authorized || viewModel.photoStatus == .limited {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "PhotoPermissionView.selectPhotoTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        PhotosPicker(
                            selection: $viewModel.selectedPhoto,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            Text(String(localized: "PhotoPermissionView.selectPhotoButton"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
                    
                    // Отображение выбранного фото
                    if let selectedImage = viewModel.selectedImage {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(String(localized: "PhotoPermissionView.selectedPhotoTitle"))
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 300)
                                .cornerRadius(12)
                        }
                        .padding()
                        .background(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(String(localized: "PhotoPermissionView.title"))
        .onAppear {
            viewModel.checkPhotoStatus()
            viewModel.loadSavedPhoto()
        }
        .onChange(of: viewModel.selectedPhoto) { oldValue, newValue in
            viewModel.loadPhoto(from: newValue)
        }
        .alert(String(localized: "PhotoPermissionView.alertTitle"), isPresented: $viewModel.showAlert) {
            Button(String(localized: "AlertView.ok"), role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    NavigationView {
        PhotoPermissionView()
    }
}
