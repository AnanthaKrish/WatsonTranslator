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
        speechRecorder.startRecordingAudio(language: inputLanguagePickerController.selectedLanguage) { [weak self] transcription, error in
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

    let inputLanguagePickerController = LanguagePickerController()
    let outputLanguagePickerController = LanguagePickerController()

    let speechRecorder = SpeechRecorder()
    let translator = Translator()
    let speaker = Speaker()

    override func viewDidLoad() {
        super.viewDidLoad()

        speechRecorder.inputLanguagePickerController = inputLanguagePickerController

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
        outputLanguagePicker.dataSource = outputLanguagePickerController

        inputLanguagePicker.delegate = inputLanguagePickerController
        outputLanguagePicker.delegate = outputLanguagePickerController

        // Yes, this is 2-way ownership
        // The controllers have a weak reference to its picker to avoid retain cycles
        inputLanguagePickerController.picker = inputLanguagePicker
        outputLanguagePickerController.picker = outputLanguagePicker
    }

    // Translates the input text and displays it in the output text
    // Once the translation is completed, it is read aloud
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
                    self?.speaker.readAloud(text: translation)
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
