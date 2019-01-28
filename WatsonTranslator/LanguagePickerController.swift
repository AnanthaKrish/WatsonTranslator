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
            picker?.reloadAllComponents()
            if supportedLanguages.count > 0 {
                DispatchQueue.main.async {
                    let defaultLanguageRow = self.supportedLanguages.firstIndex(of: .english) ?? self.supportedLanguages.count / 2
                    self.picker?.selectRow(defaultLanguageRow, inComponent: 0, animated: false)
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
    }
}
