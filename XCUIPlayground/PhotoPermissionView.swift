import SwiftUI
import PhotosUI
import Photos

struct PhotoPermissionView: View {
    @AppStorage("savedPhotoData") private var savedPhotoData: Data?
    @State private var photoStatus: PHAuthorizationStatus = .notDetermined
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Кнопка запроса разрешения
                if photoStatus != .authorized && photoStatus != .limited {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "PhotoPermissionView.requestTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Button(action: {
                            requestPhotoPermission()
                        }) {
                            Text(String(localized: "PhotoPermissionView.requestButton"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(photoStatus == .denied ? Color.gray : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(photoStatus == .denied)
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
                }
                
                // Кнопка открытия настроек
                if photoStatus == .denied {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "PhotoPermissionView.settingsTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Button(action: {
                            openSettings()
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
                if photoStatus == .authorized || photoStatus == .limited {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "PhotoPermissionView.selectPhotoTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        PhotosPicker(
                            selection: $selectedPhoto,
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
                    if let selectedImage = selectedImage {
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
            checkPhotoStatus()
            loadSavedPhoto()
        }
        .onChange(of: selectedPhoto) { oldValue, newValue in
            loadPhoto(from: newValue)
        }
        .alert(String(localized: "PhotoPermissionView.alertTitle"), isPresented: $showAlert) {
            Button(String(localized: "AlertView.ok"), role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func checkPhotoStatus() {
        photoStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    private func requestPhotoPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                photoStatus = status
                if status == .authorized || status == .limited {
                    alertMessage = String(localized: "PhotoPermissionView.successMessage")
                    showAlert = true
                } else if status == .denied {
                    alertMessage = String(localized: "PhotoPermissionView.deniedMessage")
                    showAlert = true
                }
            }
        }
    }
    
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func loadPhoto(from item: PhotosPickerItem?) {
        guard let item = item else { return }
        
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        selectedImage = image
                        // Сохраняем фото
                        savedPhotoData = data
                    }
                case .failure(let error):
                    alertMessage = String(localized: "PhotoPermissionView.loadError") + ": \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
    
    private func loadSavedPhoto() {
        if let data = savedPhotoData, let image = UIImage(data: data) {
            selectedImage = image
        }
    }
}

#Preview {
    NavigationView {
        PhotoPermissionView()
    }
}

