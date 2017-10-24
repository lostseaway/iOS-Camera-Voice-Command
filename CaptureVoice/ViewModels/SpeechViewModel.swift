//
//  SpeechViewModel.swift
//  CaptureVoice
//
//  Created by SSLostSeaWay MacBookPro on 10/24/2560 BE.
//  Copyright © 2560 ShopSpot. All rights reserved.
//

import AVFoundation
import Speech

class SpeechViewModel {
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var speechSynthesizer = AVSpeechSynthesizer()
    
    func startRecording(callback: @escaping (String) -> Void) throws {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        recognitionTask = speechRecognizer.recognitionTask(with: request) { result, error in
            
            if let result = result {
                let rawWord = result.bestTranscription.formattedString.lowercased().components(separatedBy: " ").last
                guard let word = rawWord else {
                    return
                }
                callback(word)
            }
        }
    }
    
    func cancelRecording() {
        audioEngine.stop()
        request.endAudio()
        recognitionTask?.cancel()
    }
}
