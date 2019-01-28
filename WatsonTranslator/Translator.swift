//
//  Translator.swift
//  WatsonTranslator
//
//  Created by Anthony Oliveri on 1/15/19.
//  Copyright © 2019 IBM. All rights reserved.
//

import Foundation
import LanguageTranslator


class Translator {

    let languageTransltor: LanguageTranslator
    var supportedTranslations: [TranslationModel]?
    var translationsLoaded: Bool = false

    init() {
        languageTransltor = LanguageTranslator(version: "2018-05-01", apiKey: Credentials.LanguageTranslatorAPIKey)
        languageTransltor.serviceURL = Credentials.LanguageTranslatorURL
        
        loadSupportedTranslations()
    }

    // Translate the provided text with the inputLanguage and outputLanguage specified for this Translator instance
    func translate(_ text: String, inputLanguage: Language, outputLanguage: Language, completionHandler: @escaping (_ translation: String?, _ error: String?) -> Void) {
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

    func loadSupportedTranslations() {
        // Don't need to make an unnecessary network call if supportedInputLanguages is already loaded
        guard supportedTranslations == nil else { return }

        languageTransltor.listModels() {
            response, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let models = response?.result?.models else {
                print("Failed to get the translation models")
                return
            }

            self.supportedTranslations = models
            self.translationsLoaded = true
        }
    }

    func getSupportedTranslations(for language: Language) -> [Language] {
        let asdf = supportedTranslations?
            .filter{ $0.source == language.rawValue }
            .map{ $0.targetLanguageModel }
            ?? []

        return asdf
    }
}

extension TranslationModel {

    // Convert to custom Language type
    // Defaults to English, but this should never happen
    // unless the LanguageTranslator service gets a new language that's not yet in the Language type
    var targetLanguageModel: Language {
        return Language.allCases.first(where: { language -> Bool in
            language.rawValue == self.target
        }) ?? .english
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
}
