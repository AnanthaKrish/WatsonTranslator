//
//  Translator.swift
//  WatsonTranslator
//
//  Created by Anthony Oliveri on 1/15/19.
//  Copyright © 2019 IBM. All rights reserved.
//

import Foundation
import LanguageTranslator


struct Translator {

    var inputLanguage: Language
    var outputLanguage: Language
    let languageTransltor: LanguageTranslator

    init(inputLanguage: Language, outputLanguage: Language) {
        self.inputLanguage = inputLanguage
        // TODO: Need to verify that the output language is supported for the provided input language
        self.outputLanguage = outputLanguage

        languageTransltor = LanguageTranslator(version: "2018-05-01", apiKey: Credentials.LanguageTranslatorAPIKey)
        languageTransltor.serviceURL = Credentials.LanguageTranslatorURL
    }

    func translate(_ text: String) {
        languageTransltor.translate(text: [text], modelID: nil, source: inputLanguage.rawValue, target: outputLanguage.rawValue) { response, error in

            if let error = error {
                print(error)
            }

            guard let result = response?.result else {
                print("Failed to get result")
                return
            }
            // TODO: Display output in the view
            print(result.translations.map{ $0.translationOutput })
        }
    }
}

enum Language: String {
    case arabic = "ar"
    case catalan = "ca"
    case chinese_simplified = "zh"
    case chinese_traditional = "zh-TW"
    case czech = "cs"
    case danish = "da"
    case dutch = "nl"
    case english = "en"
    case finnish = "fi"
    case french = "fr"
    case german = "de"
    case hindi = "hi"
    case hungarian = "hu"
    case italian = "it"
    case japanese = "ja"
    case korean = "ko"
    case norwegian_bokmål = "nb"
    case polish = "pl"
    case portuguese = "pt"
    case russian = "ru"
    case spanish = "es"
    case swedish = "sv"
    case turkish = "tr"
}
