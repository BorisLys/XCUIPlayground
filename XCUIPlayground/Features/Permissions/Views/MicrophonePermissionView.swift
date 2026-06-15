import AVFoundation
import SwiftUI

struct MicrophonePermissionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = MicrophonePermissionViewModel()
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                if viewModel.isAuthorized {
                    recordingsContent
                } else {
                    permissionContent
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            if viewModel.isAuthorized {
                recorderDock
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.checkStatus()
        }
        .onChange(of: viewModel.isSearchPresented) { _, isPresented in
            isSearchFocused = isPresented
        }
        .alert(String(localized: "MicrophonePermissionView.alertTitle"), isPresented: $viewModel.showAlert) {
            Button(String(localized: "AlertView.ok"), role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
        .sheet(isPresented: $viewModel.showNameRecordingSheet) {
            RecordingNameSheet(viewModel: viewModel)
                .presentationDetents([.height(260)])
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 22) {
            HStack(spacing: 16) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.white.opacity(0.11))
                        .clipShape(Circle())
                }
                .accessibilityLabel(String(localized: "Назад"))

                Spacer()

                Button {
                    viewModel.toggleSearch()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 28, weight: .regular))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.white.opacity(0.11))
                        .clipShape(Circle())
                }
                .accessibilityLabel(String(localized: "Поиск"))

                Button {
                    viewModel.setSelectionMode(!viewModel.isSelectionMode)
                } label: {
                    Text(viewModel.isSelectionMode ? String(localized: "Отменить") : String(localized: "Выбрать"))
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .frame(height: 56)
                        .background(Color.white.opacity(0.11))
                        .clipShape(Capsule())
                }
                .accessibilityLabel(String(localized: "Выбрать записи"))
                .disabled(!viewModel.hasSavedRecordings)
                .opacity(viewModel.hasSavedRecordings ? 1 : 0.45)
            }

            Text(String(localized: "Все записи"))
                .font(.system(size: 42, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            if viewModel.isSearchPresented {
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.45))

                    TextField(String(localized: "Поиск"), text: $viewModel.searchText)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($isSearchFocused)
                        .foregroundColor(.white)

                    if !viewModel.searchText.isEmpty {
                        Button {
                            viewModel.searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.45))
                        }
                        .accessibilityLabel(String(localized: "Очистить поиск"))
                    }
                }
                .padding(.horizontal, 14)
                .frame(height: 44)
                .background(Color.white.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.horizontal, 22)
        .padding(.top, 18)
        .padding(.bottom, 14)
    }

    private var permissionContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                permissionPanel

                if viewModel.authorizationStatus == .denied || viewModel.authorizationStatus == .restricted {
                    settingsPanel
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 8)
        }
    }

    private var permissionPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "MicrophonePermissionView.requestTitle"))
                .font(.headline)
                .foregroundColor(.white)

            Button {
                viewModel.requestPermission()
            } label: {
                Text(String(localized: "MicrophonePermissionView.requestButton"))
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        viewModel.authorizationStatus == .denied || viewModel.authorizationStatus == .restricted
                            ? Color.gray : Color.red
                    )
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(viewModel.authorizationStatus == .denied || viewModel.authorizationStatus == .restricted)
        }
        .padding(18)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var settingsPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "MicrophonePermissionView.settingsTitle"))
                .font(.headline)
                .foregroundColor(.white)

            Button {
                viewModel.openSettings()
            } label: {
                Text(String(localized: "MicrophonePermissionView.settingsButton"))
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(18)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var recordingsContent: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if viewModel.hasVisibleRecordings {
                    ForEach(viewModel.filteredRecordings) { recording in
                        RecordingRow(
                            recording: recording,
                            dateText: viewModel.formattedDate(recording.createdAt),
                            durationText: viewModel.formattedDuration(recording.duration),
                            isSelectionMode: viewModel.isSelectionMode,
                            isSelected: viewModel.isSelected(recording),
                            isExpanded: viewModel.expandedRecordingID == recording.id
                        ) {
                            viewModel.selectRecording(recording)
                        }

                        if viewModel.expandedRecordingID == recording.id && !viewModel.isSelectionMode {
                            PlaybackControls(
                                currentTime: $viewModel.playbackCurrentTime,
                                duration: viewModel.playbackDuration,
                                isPlaying: viewModel.isPlaying,
                                formattedCurrentTime: viewModel.formattedDuration(viewModel.playbackCurrentTime),
                                formattedRemainingTime: "-\(viewModel.formattedDuration(max(viewModel.playbackDuration - viewModel.playbackCurrentTime, 0)))",
                                playOrPause: {
                                    viewModel.togglePlayback(for: recording)
                                },
                                skipBackward: {
                                    viewModel.skipPlayback(by: -15)
                                },
                                skipForward: {
                                    viewModel.skipPlayback(by: 15)
                                },
                                seek: { time in
                                    viewModel.seekPlayback(to: time)
                                },
                                delete: {
                                    viewModel.deleteRecording(recording)
                                }
                            )
                        }
                    }
                } else {
                    emptyState
                }
            }
            .padding(.horizontal, 22)
            .padding(.bottom, viewModel.isRecording ? 210 : 150)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "waveform")
                .font(.system(size: 42, weight: .regular))
                .foregroundColor(.white.opacity(0.35))

            Text(viewModel.searchText.isEmpty ? String(localized: "Записей пока нет") : String(localized: "Ничего не найдено"))
                .font(.headline)
                .foregroundColor(.white.opacity(0.72))

            Text(viewModel.searchText.isEmpty
                 ? String(localized: "Нажмите красную кнопку, чтобы начать запись.")
                 : String(localized: "Попробуйте изменить запрос."))
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.45))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 72)
    }

    private var recorderDock: some View {
        VStack(spacing: 18) {
            if viewModel.isSelectionMode {
                Button(role: .destructive) {
                    viewModel.deleteSelectedRecordings()
                } label: {
                    Text(String(localized: "Удалить") + selectedCountSuffix)
                        .font(.headline)
                        .foregroundColor(viewModel.selectedRecordingsCount > 0 ? .red : .white.opacity(0.35))
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .disabled(viewModel.selectedRecordingsCount == 0)
            } else if viewModel.isRecording {
                VStack(spacing: 12) {
                    Text(viewModel.formattedDuration(viewModel.recordingElapsedTime))
                        .font(.system(size: 44, weight: .semibold, design: .rounded))
                        .monospacedDigit()
                        .foregroundColor(.white)

                    VoiceWaveformView(isRecording: viewModel.isRecording)
                        .frame(height: 52)
                        .padding(.horizontal, 32)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            if !viewModel.isSelectionMode {
                Button {
                    if viewModel.isRecording {
                        viewModel.stopRecording()
                    } else {
                        viewModel.startRecording()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.16), lineWidth: 6)
                            .frame(width: 86, height: 86)

                        if viewModel.isRecording {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.red)
                                .frame(width: 34, height: 34)
                        } else {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 70, height: 70)
                        }
                    }
                }
                .accessibilityLabel(
                    viewModel.isRecording
                        ? String(localized: "Остановить запись")
                        : String(localized: "Начать запись")
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 32)
        .background(
            LinearGradient(
                colors: [.black.opacity(0), .black.opacity(0.9), .black],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: viewModel.isRecording ? 250 : 150),
            alignment: .bottom
        )
        .animation(.easeInOut(duration: 0.2), value: viewModel.isRecording)
    }

    private var selectedCountSuffix: String {
        viewModel.selectedRecordingsCount > 0 ? " (\(viewModel.selectedRecordingsCount))" : ""
    }
}

private struct RecordingRow: View {
    let recording: SavedMicrophoneRecording
    let dateText: String
    let durationText: String
    let isSelectionMode: Bool
    let isSelected: Bool
    let isExpanded: Bool
    let select: () -> Void

    var body: some View {
        Button {
            select()
        } label: {
            VStack(spacing: 0) {
                HStack(alignment: .firstTextBaseline, spacing: 16) {
                    if isSelectionMode {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(isSelected ? .blue : .white.opacity(0.38))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(recording.title)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)

                        Text(dateText)
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.white.opacity(0.46))
                            .lineLimit(1)
                    }

                    Spacer(minLength: 12)

                    if isExpanded {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.blue)
                    } else {
                        Text(durationText)
                            .font(.system(size: 18, weight: .regular))
                            .monospacedDigit()
                            .foregroundColor(.white.opacity(0.48))
                    }
                }
                .padding(.vertical, 15)

                Divider()
                    .overlay(Color.white.opacity(0.18))
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(recording.title), \(durationText)")
    }
}

private struct PlaybackControls: View {
    @Binding var currentTime: TimeInterval

    let duration: TimeInterval
    let isPlaying: Bool
    let formattedCurrentTime: String
    let formattedRemainingTime: String
    let playOrPause: () -> Void
    let skipBackward: () -> Void
    let skipForward: () -> Void
    let seek: (TimeInterval) -> Void
    let delete: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Slider(
                    value: $currentTime,
                    in: 0...max(duration, 0.1),
                    onEditingChanged: { isEditing in
                        if !isEditing {
                            seek(currentTime)
                        }
                    }
                )
                .tint(.white.opacity(0.28))

                HStack {
                    Text(formattedCurrentTime)

                    Spacer()

                    Text(formattedRemainingTime)
                }
                .font(.system(size: 16, weight: .regular))
                .monospacedDigit()
                .foregroundColor(.white.opacity(0.58))
            }

            HStack {
                Image(systemName: "waveform")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.blue)
                    .frame(width: 48, height: 48)

                Spacer()

                Button {
                    skipBackward()
                } label: {
                    Image(systemName: "gobackward.15")
                        .font(.system(size: 34, weight: .regular))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                }
                .accessibilityLabel(String(localized: "Назад на 15 секунд"))

                Spacer()

                Button {
                    playOrPause()
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 46, weight: .regular))
                        .foregroundColor(.white)
                        .frame(width: 64, height: 64)
                }
                .accessibilityLabel(isPlaying ? String(localized: "Пауза") : String(localized: "Воспроизвести"))

                Spacer()

                Button {
                    skipForward()
                } label: {
                    Image(systemName: "goforward.15")
                        .font(.system(size: 34, weight: .regular))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                }
                .accessibilityLabel(String(localized: "Вперёд на 15 секунд"))

                Spacer()

                Button(role: .destructive) {
                    delete()
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 30, weight: .regular))
                        .foregroundColor(.blue)
                        .frame(width: 48, height: 48)
                }
                .accessibilityLabel(String(localized: "Удалить запись"))
            }

            Divider()
                .overlay(Color.white.opacity(0.18))
        }
        .padding(.top, 10)
        .padding(.bottom, 24)
    }
}

private struct VoiceWaveformView: View {
    let isRecording: Bool

    var body: some View {
        TimelineView(.animation(minimumInterval: 0.18)) { timeline in
            HStack(alignment: .center, spacing: 5) {
                ForEach(0..<26, id: \.self) { index in
                    Capsule()
                        .fill(index.isMultiple(of: 3) ? Color.red : Color.white.opacity(0.86))
                        .frame(width: 4, height: barHeight(index: index, date: timeline.date))
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func barHeight(index: Int, date: Date) -> CGFloat {
        guard isRecording else { return 8 }

        let time = date.timeIntervalSinceReferenceDate
        let wave = abs(sin(time * 3.8 + Double(index) * 0.55))
        return 10 + CGFloat(wave) * 38
    }
}

private struct RecordingNameSheet: View {
    @ObservedObject var viewModel: MicrophonePermissionViewModel
    @FocusState private var isNameFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 18) {
                Text("\(String(localized: "Длительность")): \(viewModel.formattedDuration(viewModel.pendingRecordingDuration))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                TextField(String(localized: "Название записи"), text: $viewModel.pendingRecordingTitle)
                    .textFieldStyle(.roundedBorder)
                    .focused($isNameFocused)

                Spacer()
            }
            .padding()
            .navigationTitle(String(localized: "Сохранить запись"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Удалить"), role: .destructive) {
                        viewModel.discardPendingRecording()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Сохранить")) {
                        viewModel.savePendingRecording()
                    }
                }
            }
            .onAppear {
                isNameFocused = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        MicrophonePermissionView()
    }
}
