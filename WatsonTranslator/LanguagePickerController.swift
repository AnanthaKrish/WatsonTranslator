//
//  LanguagePickerController.swift
//  WatsonTranslator
//
//  Created by Anthony Oliveri on 1/20/19.
//  Copyright © 2019 IBM. All rights reserved.
//

import Foundation
import UIKit


class LanguagePickerController: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

    weak var picker: UIPickerView?
    var selectedLanguage: Language?
    var supportedLanguages: [Language] = [] {
        didSet {
            guard let picker = picker else { return }
            picker.reloadAllComponents()
            if supportedLanguages.count > 0 {
                DispatchQueue.main.async {
                    let defaultLanguageRow = self.supportedLanguages.firstIndex(of: .english) ?? self.supportedLanguages.count / 2
                    picker.selectRow(defaultLanguageRow, inComponent: 0, animated: false)
                    self.pickerView(picker, didSelectRow: defaultLanguageRow, inComponent: 0)
                }
            }
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return supportedLanguages.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = pickerLabel?.font.withSize(16)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = supportedLanguages[row].displayName
        return pickerLabel!
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLanguage = supportedLanguages[row]
    }
}


class InputLanguagePickerController: LanguagePickerController {

    weak var outputLanguagePickerController: LanguagePickerController?
    weak var translator: Translator?
    weak var listener: Listener? {
        didSet {
            if let listener = listener {
                supportedLanguages = listener.supportedInputLanguages.map{ $0.languageModel }
            }
        }
    }

    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        super.pickerView(pickerView, didSelectRow: row, inComponent: component)
        if let selectedLanguage = selectedLanguage,
            let supportedTranslations = translator?.getSupportedTranslations(for: selectedLanguage)
        {
            outputLanguagePickerController?.supportedLanguages = supportedTranslations
        }
    }
}
