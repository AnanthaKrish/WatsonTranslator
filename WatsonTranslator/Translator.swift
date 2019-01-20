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
        // This should be done at the UI level (output language options determined by the chosen input language)
        self.outputLanguage = outputLanguage

        languageTransltor = LanguageTranslator(version: "2018-05-01", apiKey: Credentials.LanguageTranslatorAPIKey)
        languageTransltor.serviceURL = Credentials.LanguageTranslatorURL
    }

    // Translate the provided text with the inputLanguage and outputLanguage specified for this Translator instance
    func translate(_ text: String, completionHandler: @escaping (_ translation: String?, _ error: String?) -> Void) {
        languageTransltor.translate(
            text: [text],
            modelID: nil,
            source: inputLanguage.rawValue,
            target: outputLanguage.rawValue)
        {
            response, error in

            guard error == nil else {
                completionHandler(nil, error?.errorDescription)
                return
            }

            guard let result = response?.result else {
                completionHandler(nil, "Failed to get the translation")
                return
            }
            completionHandler(result.translations[0].translationOutput, nil)
        }
    }
}

enum Language: String, CaseIterable {
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

    var displayName: String {
        switch self {
        case .arabic: return "Arabic"
        case .catalan: return "Catalan"
        case .chinese_simplified: return "Chinese simplified"
        case .chinese_traditional: return "Chinese traditional"
        case .czech: return "Czech"
        case.danish: return "Danish"
        case .dutch: return "Dutch"
        case .english: return "English"
        case .finnish: return "Finnish"
        case .french: return "French"
        case .german: return "German"
        case .hindi: return "Hindi"
        case .hungarian: return "Hungarian"
        case .italian: return "Italian"
        case .japanese: return "Japanese"
        case .korean: return "Korean"
        case .norwegian_bokmål: return "Norwegian"
        case .polish: return "Polish"
        case .portuguese: return "Portuguese"
        case .russian: return "Russian"
        case .spanish: return "Spanish"
        case .swedish: return "Swedish"
        case .turkish: return "Turkish"
        }
    }

    // Watson LanguageTranslator can only translate between certain languages
    // https://console.bluemix.net/docs/services/language-translator/translation-models.html#translation-models
    func canTranslateTo(_ other: Language) -> Bool {
        // This could be simplified with a [Language: [Language]] dictionary,
        // but a switch statement is more reliable to ensure every case is captured
        switch self {
        case .arabic:
            return other == .english
        case .catalan:
            return other == .english
        case .chinese_simplified:
            return other == .english
        case .chinese_traditional:
            return other == .english
        case .czech:
            return other == .english
        case.danish:
            return other == .english
        case .dutch:
            return other == .english
        case .english:
            return other != .catalan && other != .hungarian
        case .finnish:
            return other == .english
        case .french:
            return other == .german || other == .english || other == .spanish
        case .german:
            return other == .english || other == .french || other == .italian
        case .hindi:
            return other == .english
        case .hungarian:
            return other == .english
        case .italian:
            return other == .german || other == .english
        case .japanese:
            return other == .english
        case .korean:
            return other == .english
        case .norwegian_bokmål:
            return other == .english
        case .polish:
            return other == .english
        case .portuguese:
            return other == .english
        case .russian:
            return other == .english
        case .spanish:
            return other == .catalan || other == .english || other == .french
        case .swedish:
            return other == .english
        case .turkish:
            return other == .english
        }
    }
}
