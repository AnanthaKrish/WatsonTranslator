//
//  Language.swift
//  WatsonTranslator
//
//  Created by Anthony Oliveri on 1/27/19.
//  Copyright © 2019 IBM. All rights reserved.
//

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
