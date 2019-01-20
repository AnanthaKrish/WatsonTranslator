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

    var selectedLanguage: Language?

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Language.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = pickerLabel?.font.withSize(16)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = Language.allCases[row].displayName
        return pickerLabel!
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLanguage = Language.allCases[row]
    }
}
