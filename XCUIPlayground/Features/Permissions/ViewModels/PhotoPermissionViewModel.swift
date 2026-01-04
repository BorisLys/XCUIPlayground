import SwiftUI
import Combine
import PhotosUI
import Photos
import UIKit

final class PhotoPermissionViewModel: ObservableObject {
    private let savedPhotoKey = "savedPhotoData"

    @Published var photoStatus: PHAuthorizationStatus = .notDetermined
    @Published var selectedPhoto: PhotosPickerItem?
    @Published var selectedImage: UIImage?
    @Published var showAlert = false
    @Published var alertMessage: String = ""

    func checkPhotoStatus() {
        photoStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }

    func requestPhotoPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            DispatchQueue.main.async {
                self?.photoStatus = status
                if status == .authorized || status == .limited {
                    self?.alertMessage = String(localized: "PhotoPermissionView.successMessage")
                    self?.showAlert = true
                } else if status == .denied {
                    self?.alertMessage = String(localized: "PhotoPermissionView.deniedMessage")
                    self?.showAlert = true
                }
            }
        }
    }

    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    func loadPhoto(from item: PhotosPickerItem?) {
        guard let item else { return }

        item.loadTransferable(type: Data.self) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let data):
                    if let data, let image = UIImage(data: data) {
                        self.selectedImage = image
                        UserDefaults.standard.set(data, forKey: self.savedPhotoKey)
                    }
                case .failure(let error):
                    self.alertMessage = String(localized: "PhotoPermissionView.loadError") + ": \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
        }
    }

    func loadSavedPhoto() {
        if let data = UserDefaults.standard.data(forKey: savedPhotoKey),
           let image = UIImage(data: data) {
            selectedImage = image
        }
    }
}
