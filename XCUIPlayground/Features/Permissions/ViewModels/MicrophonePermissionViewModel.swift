import AVFoundation
import Combine
import SwiftUI

final class MicrophonePermissionViewModel: ObservableObject {
    @Published var authorizationStatus: AVAuthorizationStatus = .notDetermined
    @Published var isRecording = false
    @Published var hasRecording = false
    @Published var showAlert = false
    @Published var alertMessage: String = ""

    var isAuthorized: Bool { authorizationStatus == .authorized }

    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordingURL: URL {
        FileManager.default.temporaryDirectory.appendingPathComponent("mic_test.m4a")
    }

    func checkStatus() {
        authorizationStatus = AVCaptureDevice.authorizationStatus(for: .audio)
    }

    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .audio) { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.alertMessage = String(localized: "MicrophonePermissionView.successMessage")
                } else {
                    self?.alertMessage = String(localized: "MicrophonePermissionView.deniedMessage")
                }
                self?.showAlert = true
                self?.checkStatus()
            }
        }
    }

    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    func startRecording() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try session.setActive(true)
        } catch {
            alertMessage = String(localized: "MicrophonePermissionView.errorMessage") + ": \(error.localizedDescription)"
            showAlert = true
            return
        }

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL, settings: settings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record(forDuration: 3)
            isRecording = true
        } catch {
            alertMessage = String(localized: "MicrophonePermissionView.errorMessage") + ": \(error.localizedDescription)"
            showAlert = true
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) { [weak self] in
            self?.stopRecording()
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        hasRecording = FileManager.default.fileExists(atPath: recordingURL.path)
    }

    func playRecording() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default)
        try? session.setActive(true)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
            audioPlayer?.play()
        } catch {
            alertMessage = String(localized: "MicrophonePermissionView.errorMessage") + ": \(error.localizedDescription)"
            showAlert = true
        }
    }
}
