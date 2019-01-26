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

    init() {
        textToSpeech = TextToSpeech(apiKey: Credentials.TextToSpeechAPIKey)
    }

    func readAloud(text: String) {
        textToSpeech.synthesize(text: text, accept: "audio/wav", voice: nil) {
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
}
