//
//  ViewController.swift
//  WatsonTranslator
//
//  Created by Anthony Oliveri on 1/12/19.
//  Copyright © 2019 IBM. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var inputLanguagePicker: UIPickerView!
    @IBOutlet weak var outputLanguagePicker: UIPickerView!

    @IBAction func translateButtonHeld(_ sender: UIButton) {
        speechRecorder.startRecordingAudio() { [weak self] transcription, error in
            DispatchQueue.main.async {
                if let transcription = transcription {
                    self?.inputTextView.text = transcription
                    self?.translate()
                }
                else if let error = error {
                    self?.showError(message: error)
                }
            }
        }
    }

    @IBAction func translateButtonLifted(_ sender: UIButton) {
        speechRecorder.stopRecordingAudio()
    }


    let speechRecorder = SpeechRecorder()
    let inputLanguagePickerController = LanguagePickerController()
    let outputLanguagePickerController = LanguagePickerController()


    override func viewDidLoad() {
        super.viewDidLoad()

        AVAudioSession.sharedInstance().requestRecordPermission { _ in }

        configureTextViews()
        configureLanguagePickers()
    }

    func configureTextViews() {
        inputTextView.layer.borderWidth = 2.0
        outputTextView.layer.borderWidth = 2.0

        inputTextView.layer.cornerRadius = 10.0
        outputTextView.layer.cornerRadius = 10.0

        inputTextView.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
        outputTextView.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor

        // It would be easiest for the recipient to view the translation on the device upside-down
        UIView.animate(withDuration: 0.0) {
            self.outputTextView.transform = CGAffineTransform(rotationAngle: .pi)
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

    func translate() {
        guard
            let inputLanguage = self.inputLanguagePickerController.selectedLanguage,
            let outputLanguage = self.outputLanguagePickerController.selectedLanguage else {
                self.showError(message: "Invalid language selections")
                return
        }

        let translator = Translator(inputLanguage: inputLanguage, outputLanguage: outputLanguage)
        translator.translate(self.inputTextView.text) { [weak self] translation, error in
            DispatchQueue.main.async {
                if let translation = translation {
                    self?.outputTextView.text = translation
                }
                else if let error = error {
                    self?.showError(message: error)
                }
            }
        }
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
