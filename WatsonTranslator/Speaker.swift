//
//  Speaker.swift
//  WatsonTranslator
//
//  Created by Anthony Oliveri on 1/24/19.
//  Copyright © 2019 IBM. All rights reserved.
//

import Foundation
import AVFoundation
import TextToSpeech

class Speaker {

    let textToSpeech: TextToSpeech
    var audioPlayer: AVAudioPlayer?
    var supportedVoices: [Voice]?

    init() {
        textToSpeech = TextToSpeech(apiKey: Credentials.TextToSpeechAPIKey)
        loadAllVoices()
    }

    func readAloud(text: String, language: Language) {
        guard let supportedVoices = supportedVoices else { return }

        let voice = supportedVoices.first { voice -> Bool in
            return voice.languageID == language.rawValue
        }
        guard voice != nil else { return }
        
        textToSpeech.synthesize(text: text, accept: "audio/wav", voice: voice?.name) {
            response, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let speech: Data = response?.result else {
                print("unknown error when synthesizing speech")
                return
            }
            do {
                self.audioPlayer = try AVAudioPlayer(data: speech)
                self.audioPlayer?.prepareToPlay()
                self.audioPlayer?.play()
            }
            catch {
                print(error)
            }
        }
    }

    func loadAllVoices() {
        // Don't need to make an unnecessary network call if allVoices is already loaded
        guard supportedVoices == nil else { return }

        textToSpeech.listVoices() {
            response, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let voices = response?.result?.voices else {
                print("Failed to retrieve voices")
                return
            }

            self.supportedVoices = voices
        }
    }
}


extension Voice {
    // Used to match a Voice object to the Language type
    var languageID: String {
        return String(self.language.prefix(2))
    }
}
