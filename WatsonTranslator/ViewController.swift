//
//  ViewController.swift
//  WatsonTranslator
//
//  Created by Anthony Oliveri on 1/12/19.
//  Copyright © 2019 IBM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var inputLanguagePicker: UIPickerView!
    @IBOutlet weak var outputLanguagePicker: UIPickerView!

    @IBAction func translateButtonTapped(_ sender: UIButton) {
        guard
            let inputLanguage = inputLanguagePickerController.selectedLanguage,
            let outputLanguage = outputLanguagePickerController.selectedLanguage else {
                print("Failed to get selected languages")
                return
        }

        let translator = Translator(inputLanguage: inputLanguage, outputLanguage: outputLanguage)
        translator.translate(inputTextView.text) { translation in
            DispatchQueue.main.async {
                self.outputTextView.text = translation
            }
        }
    }


    let inputLanguagePickerController = LanguagePickerController()
    let outputLanguagePickerController = LanguagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // It would be easiest for the recipient to view the translation on the device upside-down
        flipViewUpsideDown(outputTextView)
        configureLanguagePickers()
    }

    func flipViewUpsideDown(_ view: UIView) {
        UIView.animate(withDuration: 0.0) {
            view.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }

    // Set the pickers' delegates and data sources, and set default selected values
    func configureLanguagePickers() {
        inputLanguagePicker.dataSource = inputLanguagePickerController
        inputLanguagePicker.delegate = inputLanguagePickerController
        outputLanguagePicker.dataSource = outputLanguagePickerController
        outputLanguagePicker.delegate = outputLanguagePickerController

        // Default the input to English for easier testing
        let rowForEnglish = Language.allCases.firstIndex(of: .english)!
        inputLanguagePicker.selectRow(rowForEnglish, inComponent: 0, animated: false)
        inputLanguagePickerController.pickerView(inputLanguagePicker, didSelectRow: rowForEnglish, inComponent: 0)
        // Default the output to Spanish for easier testing
        let rowForSpanish = Language.allCases.firstIndex(of: .spanish)!
        outputLanguagePicker.selectRow(rowForSpanish, inComponent: 0, animated: false)
        outputLanguagePickerController.pickerView(outputLanguagePicker, didSelectRow: rowForSpanish, inComponent: 0)
    }
}
