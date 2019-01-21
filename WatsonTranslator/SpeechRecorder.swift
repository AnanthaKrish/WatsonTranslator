//
//  SpeechRecorder.swift
//  WatsonTranslator
//
//  Created by Anthony Oliveri on 1/20/19.
//  Copyright © 2019 IBM. All rights reserved.
//

import Foundation
import SpeechToText


class SpeechRecorder {

    let speechToText: SpeechToText

    init() {
        speechToText = SpeechToText(apiKey: Credentials.SpeechToTextAPIKey)
    }

    func startRecordingAudio(completionHandler: @escaping (_ transcription: String?, _ error: String?) -> Void) {
        var settings = RecognitionSettings(contentType: "audio/wav")
        settings.interimResults = false
        settings.filterProfanity = false

        speechToText.recognizeMicrophone(
            settings: settings,
            model: "en-US_BroadbandModel")
        {
            response, error in

            guard error == nil else {
                completionHandler(nil, error?.errorDescription)
                return
            }

            // Make sure that we got results, and that the results are final (not interim)
            guard
                let results = response?.result?.results,
                let transcription = results.first(where: { (result) -> Bool in result.finalResults}),
                transcription.alternatives.count > 0 else {
                    completionHandler(nil, "Failed to recognize your speech. Please try again.")
                    return
            }

            // Get the transcription with the highest confidence
            let finalTranscription = transcription.alternatives.max(by: { (transcription1, transcription2) -> Bool in
                if let confidence2 = transcription2.confidence {
                    if let confidence1 = transcription1.confidence {
                        return confidence1 > confidence2
                    }
                    return false
                }
                return true
            })

            completionHandler(finalTranscription?.transcript, nil)
        }
    }

    func stopRecordingAudio() {
        speechToText.stopRecognizeMicrophone()
    }
}
