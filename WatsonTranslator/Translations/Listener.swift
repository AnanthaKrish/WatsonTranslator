//
//  Listener.swift
//  WatsonTranslator
//
//  Created by Anthony Oliveri on 1/20/19.
//  Copyright © 2019 IBM. All rights reserved.
//

import Foundation
import SpeechToText


class Listener {

    let speechToText: SpeechToText
    var supportedInputLanguages: [SpeechModel] = []
    var inputLanguagesLoaded: Bool = false

    init() {
        speechToText = SpeechToText(apiKey: Credentials.SpeechToTextAPIKey)
        
        loadSupportedInputLanguages()
    }

    func startRecordingAudio(language: Language?, completionHandler: @escaping (_ transcription: String?, _ error: String?) -> Void) {
        var settings = RecognitionSettings(contentType: "audio/wav")
        settings.interimResults = false
        settings.filterProfanity = false

        // This may be nil. If so, SpeechToText will default to "en-US_BroadbandModel".
        let model = getModel(for: language)

        speechToText.recognizeMicrophone(
            settings: settings,
            model: model?.name)
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

    func loadSupportedInputLanguages() {
        // Don't need to make an unnecessary network call if supportedInputLanguages is already loaded
        guard supportedInputLanguages.count == 0 else { return }

        speechToText.listModels() {
            response, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let models = response?.result?.models else {
                print("unknown error when synthesizing speech")
                return
            }

            // Only want one model per language
            // Some languages have multiple models for multiple geographical regions
            models.forEach({ model in
                if !self.supportedInputLanguages.contains { $0.languageID == model.languageID } {
                    self.supportedInputLanguages.append(model)
                }
            })
            self.inputLanguagesLoaded = true
        }
    }

    func getModel(for language: Language?) -> SpeechModel? {
        guard let language = language else { return nil }
        return supportedInputLanguages.first { model -> Bool in
            return model.languageID == language.rawValue
        }
    }
}


extension SpeechModel {
    // Used to match a SpeechModel object to the Language type
    var languageID: String {
        return String(self.language.prefix(2))
    }

    // Convert to custom Language type
    // Defaults to English, but this should never happen
    // unless the SpeechToText service gets a new language that's not yet in the Language type
    var languageModel: Language {
        return Language.allCases.first(where: { language -> Bool in
            language.rawValue == self.languageID
        }) ?? .english
    }
}
