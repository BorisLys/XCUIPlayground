import AVFoundation
import Combine
import SwiftUI

struct SavedMicrophoneRecording: Identifiable, Equatable {
    var id: URL { url }

    let title: String
    let url: URL
    let createdAt: Date
    let duration: TimeInterval
}

final class MicrophonePermissionViewModel: ObservableObject {
    @Published var authorizationStatus: AVAuthorizationStatus = .notDetermined
    @Published var isRecording = false
    @Published var hasRecording = false
    @Published var recordingElapsedTime: TimeInterval = 0
    @Published var savedRecordings: [SavedMicrophoneRecording] = []
    @Published var showNameRecordingSheet = false
    @Published var pendingRecordingTitle = ""
    @Published var pendingRecordingDuration: TimeInterval = 0
    @Published var isSearchPresented = false
    @Published var searchText = ""
    @Published var isSelectionMode = false
    @Published var selectedRecordingIDs: Set<URL> = []
    @Published var expandedRecordingID: URL?
    @Published var playbackCurrentTime: TimeInterval = 0
    @Published var playbackDuration: TimeInterval = 0
    @Published var isPlaying = false
    @Published var showAlert = false
    @Published var alertMessage: String = ""

    var isAuthorized: Bool { authorizationStatus == .authorized }
    var hasSavedRecordings: Bool { !savedRecordings.isEmpty }
    var filteredRecordings: [SavedMicrophoneRecording] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !query.isEmpty else { return savedRecordings }

        return savedRecordings.filter { recording in
            recording.title.localizedCaseInsensitiveContains(query)
        }
    }
    var hasVisibleRecordings: Bool { !filteredRecordings.isEmpty }
    var selectedRecordingsCount: Int { selectedRecordingIDs.count }

    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordingTimer: Timer?
    private var playbackTimer: Timer?
    private var recordingStartDate: Date?
    private var activeRecordingURL: URL?
    private var pendingRecordingURL: URL?
    private var audioPlayerURL: URL?
    private var recordingsDirectory: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent("MicrophoneRecordings", isDirectory: true)
    }

    func checkStatus() {
        authorizationStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        loadSavedRecordings()
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
        stopRecordingTimer()
        stopPlayback()
        hasRecording = false
        recordingElapsedTime = 0

        let recordingURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("mic_test_\(UUID().uuidString)")
            .appendingPathExtension("m4a")
        activeRecordingURL = recordingURL

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

            guard audioRecorder?.record() == true else {
                audioRecorder = nil
                activeRecordingURL = nil
                alertMessage = String(localized: "MicrophonePermissionView.errorMessage")
                showAlert = true
                return
            }

            recordingStartDate = Date()
            isRecording = true
            startRecordingTimer()
        } catch {
            activeRecordingURL = nil
            alertMessage = String(localized: "MicrophonePermissionView.errorMessage") + ": \(error.localizedDescription)"
            showAlert = true
            return
        }
    }

    func stopRecording() {
        guard isRecording else { return }

        stopRecordingTimer()
        audioRecorder?.stop()
        audioRecorder = nil
        isRecording = false

        let finishedURL = activeRecordingURL
        activeRecordingURL = nil
        pendingRecordingDuration = recordingElapsedTime
        recordingStartDate = nil

        guard let finishedURL, fileSize(at: finishedURL) > 0 else {
            hasRecording = false
            pendingRecordingURL = nil
            alertMessage = String(localized: "MicrophonePermissionView.errorMessage")
            showAlert = true
            return
        }

        hasRecording = true
        pendingRecordingURL = finishedURL
        pendingRecordingTitle = defaultRecordingTitle()
        showNameRecordingSheet = true
    }

    func savePendingRecording() {
        guard let pendingRecordingURL else { return }

        let trimmedTitle = pendingRecordingTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let title = trimmedTitle.isEmpty ? defaultRecordingTitle() : trimmedTitle
        let destinationURL = uniqueRecordingURL(for: title)

        do {
            try FileManager.default.createDirectory(
                at: recordingsDirectory,
                withIntermediateDirectories: true
            )
            try FileManager.default.moveItem(at: pendingRecordingURL, to: destinationURL)
        } catch {
            alertMessage = String(localized: "MicrophonePermissionView.errorMessage") + ": \(error.localizedDescription)"
            showAlert = true
            return
        }

        let recording = SavedMicrophoneRecording(
            title: title,
            url: destinationURL,
            createdAt: Date(),
            duration: pendingRecordingDuration
        )
        savedRecordings.insert(recording, at: 0)
        self.pendingRecordingURL = nil
        pendingRecordingTitle = ""
        pendingRecordingDuration = 0
        hasRecording = false
        showNameRecordingSheet = false
    }

    func discardPendingRecording() {
        if let pendingRecordingURL {
            try? FileManager.default.removeItem(at: pendingRecordingURL)
        }
        self.pendingRecordingURL = nil
        pendingRecordingTitle = ""
        pendingRecordingDuration = 0
        hasRecording = false
        showNameRecordingSheet = false
    }

    func toggleSearch() {
        isSearchPresented.toggle()

        if !isSearchPresented {
            searchText = ""
        }
    }

    func setSelectionMode(_ isEnabled: Bool) {
        isSelectionMode = isEnabled
        selectedRecordingIDs.removeAll()

        if isEnabled {
            stopPlayback()
        }
    }

    func toggleSelection(for recording: SavedMicrophoneRecording) {
        if selectedRecordingIDs.contains(recording.id) {
            selectedRecordingIDs.remove(recording.id)
        } else {
            selectedRecordingIDs.insert(recording.id)
        }
    }

    func isSelected(_ recording: SavedMicrophoneRecording) -> Bool {
        selectedRecordingIDs.contains(recording.id)
    }

    func selectRecording(_ recording: SavedMicrophoneRecording) {
        if isSelectionMode {
            toggleSelection(for: recording)
            return
        }

        if expandedRecordingID == recording.id {
            return
        }

        stopPlayback()
        expandedRecordingID = recording.id
        playbackDuration = recording.duration
        playbackCurrentTime = 0
        preparePlayer(for: recording)
    }

    func togglePlayback(for recording: SavedMicrophoneRecording) {
        if expandedRecordingID != recording.id {
            selectRecording(recording)
        }

        if audioPlayerURL != recording.url {
            preparePlayer(for: recording)
        }

        guard let audioPlayer else { return }

        if audioPlayer.isPlaying {
            audioPlayer.pause()
            isPlaying = false
            stopPlaybackTimer()
            return
        }

        guard audioPlayer.play() else {
            alertMessage = String(localized: "MicrophonePermissionView.errorMessage")
            showAlert = true
            return
        }

        isPlaying = true
        startPlaybackTimer()
    }

    func seekPlayback(to time: TimeInterval) {
        let clampedTime = min(max(time, 0), playbackDuration)
        playbackCurrentTime = clampedTime
        audioPlayer?.currentTime = clampedTime
    }

    func skipPlayback(by seconds: TimeInterval) {
        seekPlayback(to: playbackCurrentTime + seconds)
    }

    func deleteRecording(_ recording: SavedMicrophoneRecording) {
        if expandedRecordingID == recording.id {
            stopPlayback()
        }

        try? FileManager.default.removeItem(at: recording.url)
        savedRecordings.removeAll { $0.id == recording.id }
        selectedRecordingIDs.remove(recording.id)
    }

    func deleteSelectedRecordings() {
        let selectedIDs = selectedRecordingIDs
        savedRecordings
            .filter { selectedIDs.contains($0.id) }
            .forEach { deleteRecording($0) }
        setSelectionMode(false)
    }

    private func preparePlayer(for recording: SavedMicrophoneRecording) {
        guard fileSize(at: recording.url) > 0 else {
            hasRecording = false
            alertMessage = String(localized: "MicrophonePermissionView.errorMessage")
            showAlert = true
            return
        }

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            alertMessage = String(localized: "MicrophonePermissionView.errorMessage") + ": \(error.localizedDescription)"
            showAlert = true
            return
        }

        do {
            audioPlayer?.stop()
            audioPlayer = try AVAudioPlayer(contentsOf: recording.url)
            audioPlayer?.prepareToPlay()
            audioPlayerURL = recording.url
            playbackDuration = audioPlayer?.duration ?? recording.duration
            playbackCurrentTime = audioPlayer?.currentTime ?? 0
        } catch {
            alertMessage = String(localized: "MicrophonePermissionView.errorMessage") + ": \(error.localizedDescription)"
            showAlert = true
        }
    }

    func formattedDuration(_ duration: TimeInterval) -> String {
        let totalSeconds = max(0, Int(duration.rounded()))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }

        return String(format: "%d:%02d", minutes, seconds)
    }

    func formattedDate(_ date: Date) -> String {
        date.formatted(.dateTime.day().month(.abbreviated).year())
    }

    private func startRecordingTimer() {
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self, let recordingStartDate = self.recordingStartDate else { return }
                recordingElapsedTime = Date().timeIntervalSince(recordingStartDate)
            }
        }
    }

    private func stopRecordingTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
    }

    private func startPlaybackTimer() {
        playbackTimer?.invalidate()
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.updatePlaybackProgress()
            }
        }
    }

    private func stopPlaybackTimer() {
        playbackTimer?.invalidate()
        playbackTimer = nil
    }

    private func updatePlaybackProgress() {
        guard let audioPlayer else { return }

        playbackCurrentTime = audioPlayer.currentTime
        playbackDuration = audioPlayer.duration

        if !audioPlayer.isPlaying && isPlaying {
            isPlaying = false
            stopPlaybackTimer()

            if playbackCurrentTime >= playbackDuration {
                seekPlayback(to: 0)
            }
        }
    }

    private func stopPlayback() {
        audioPlayer?.stop()
        audioPlayer = nil
        audioPlayerURL = nil
        isPlaying = false
        playbackCurrentTime = 0
        playbackDuration = 0
        expandedRecordingID = nil
        stopPlaybackTimer()
    }

    private func loadSavedRecordings() {
        guard let urls = try? FileManager.default.contentsOfDirectory(
            at: recordingsDirectory,
            includingPropertiesForKeys: [.creationDateKey],
            options: [.skipsHiddenFiles]
        ) else {
            savedRecordings = []
            return
        }

        savedRecordings = urls
            .filter { $0.pathExtension == "m4a" }
            .map { url in
                SavedMicrophoneRecording(
                    title: title(from: url),
                    url: url,
                    createdAt: creationDate(for: url),
                    duration: audioDuration(for: url)
                )
            }
            .sorted { $0.createdAt > $1.createdAt }
    }

    private func defaultRecordingTitle() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return "\(String(localized: "Новая запись")) \(formatter.string(from: Date()))"
    }

    private func uniqueRecordingURL(for title: String) -> URL {
        let timestamp = Int(Date().timeIntervalSince1970)
        let safeTitle = sanitizedFileName(title)
        var url = recordingsDirectory.appendingPathComponent("\(timestamp)-\(safeTitle).m4a")

        if FileManager.default.fileExists(atPath: url.path) {
            url = recordingsDirectory.appendingPathComponent("\(timestamp)-\(UUID().uuidString)-\(safeTitle).m4a")
        }

        return url
    }

    private func sanitizedFileName(_ title: String) -> String {
        let forbiddenCharacters = CharacterSet(charactersIn: "/\\?%*|\"<>:")
        let components = title.components(separatedBy: forbiddenCharacters)
        let name = components.joined(separator: "-").trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? "Recording" : name
    }

    private func title(from url: URL) -> String {
        let name = url.deletingPathExtension().lastPathComponent
        let title = name.drop { $0.isNumber || $0 == "-" }
        return title.isEmpty ? String(localized: "Новая запись") : String(title)
    }

    private func creationDate(for url: URL) -> Date {
        let attributes = try? FileManager.default.attributesOfItem(atPath: url.path)
        return attributes?[.creationDate] as? Date ?? Date()
    }

    private func audioDuration(for url: URL) -> TimeInterval {
        guard let player = try? AVAudioPlayer(contentsOf: url) else { return 0 }
        return player.duration
    }

    private func fileSize(at url: URL) -> UInt64 {
        let attributes = try? FileManager.default.attributesOfItem(atPath: url.path)
        return attributes?[.size] as? UInt64 ?? 0
    }
}
