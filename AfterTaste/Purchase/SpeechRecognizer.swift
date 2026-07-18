//
//  SpeechRecognizer.swift
//  AfterTaste
//
//  Created by Ruba Alghamdi on 04/02/1448 AH.
//


import Foundation
import Speech
import AVFoundation
import Combine

final class SpeechRecognizer: NSObject, ObservableObject {

    @Published var transcript: String = ""
    @Published var isRecording: Bool = false
    @Published var errorMessage: String?

    private let audioEngine = AVAudioEngine()

    private var recognitionRequest:
        SFSpeechAudioBufferRecognitionRequest?

    private var recognitionTask:
        SFSpeechRecognitionTask?

    private let recognizer =
        SFSpeechRecognizer(locale: Locale.current)


    // MARK: - Permissions

    func requestAuthorization() async -> Bool {

        let speechAllowed: Bool =
            await withCheckedContinuation { continuation in

                SFSpeechRecognizer
                    .requestAuthorization { status in

                        continuation.resume(
                            returning:
                                status == .authorized
                        )
                    }
            }


        guard speechAllowed else {

            await MainActor.run {
                self.errorMessage =
                    "Speech recognition permission was denied."
            }

            return false
        }


        let microphoneAllowed: Bool =
            await withCheckedContinuation { continuation in

                AVAudioSession
                    .sharedInstance()
                    .requestRecordPermission { allowed in

                        continuation.resume(
                            returning: allowed
                        )
                    }
            }


        guard microphoneAllowed else {

            await MainActor.run {
                self.errorMessage =
                    "Microphone permission was denied."
            }

            return false
        }


        return true
    }


    // MARK: - Start Recording

    func startRecording(
        existingText: String = ""
    ) {

        stopRecording()


        guard let recognizer,
              recognizer.isAvailable
        else {

            errorMessage =
                "Speech recognition is currently unavailable."

            return
        }


        let audioSession =
            AVAudioSession.sharedInstance()


        do {

            try audioSession.setCategory(
                .record,
                mode: .measurement,
                options: .duckOthers
            )

            try audioSession.setActive(
                true,
                options:
                    .notifyOthersOnDeactivation
            )

        } catch {

            errorMessage =
                error.localizedDescription

            return
        }


        let request =
            SFSpeechAudioBufferRecognitionRequest()


        request.shouldReportPartialResults =
            true


        recognitionRequest =
            request


        let inputNode =
            audioEngine.inputNode


        let recordingFormat =
            inputNode.outputFormat(
                forBus: 0
            )


        inputNode.installTap(
            onBus: 0,
            bufferSize: 1024,
            format: recordingFormat
        ) { buffer, _ in

            request.append(buffer)
        }


        let originalText =
            existingText
                .trimmingCharacters(
                    in:
                        .whitespacesAndNewlines
                )


        recognitionTask =
            recognizer
                .recognitionTask(
                    with: request
                ) {
                    [weak self]
                    result,
                    error in


                    guard let self else {
                        return
                    }


                    if let result {

                        let spokenText =
                            result
                                .bestTranscription
                                .formattedString


                        DispatchQueue.main.async {

                            if originalText.isEmpty {

                                self.transcript =
                                    spokenText

                            } else {

                                self.transcript =
                                    "\(originalText) \(spokenText)"
                            }
                        }


                        if result.isFinal {

                            DispatchQueue.main.async {

                                self.stopRecording()
                            }
                        }
                    }


                    if let error {

                        DispatchQueue.main.async {

                            self.errorMessage =
                                error.localizedDescription

                            self.stopRecording()
                        }
                    }
                }


        do {

            audioEngine.prepare()

            try audioEngine.start()

            isRecording = true

        } catch {

            errorMessage =
                error.localizedDescription

            stopRecording()
        }
    }


    // MARK: - Stop Recording

    func stopRecording() {

        if audioEngine.isRunning {

            audioEngine.stop()

            audioEngine
                .inputNode
                .removeTap(
                    onBus: 0
                )
        }


        recognitionRequest?
            .endAudio()


        recognitionTask?
            .cancel()


        recognitionTask =
            nil

        recognitionRequest =
            nil

        isRecording =
            false


        try?
            AVAudioSession
                .sharedInstance()
                .setActive(
                    false,
                    options:
                        .notifyOthersOnDeactivation
                )
    }
}
