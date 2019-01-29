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
    @IBOutlet weak var translateDownButton: UIButton!
    @IBOutlet weak var fadedView: UIView! // Makes the entire view less visible

    // Translating from the input language to the output language
    @IBAction func translateUpButtonHeld(_ sender: UIButton) {
        guard
            let inputLanguage = self.inputLanguagePickerController.selectedLanguage,
            let outputLanguage = self.outputLanguagePickerController.selectedLanguage else {
                self.showError(message: "Invalid language selections")
                return
        }
        transcribe(
            inputLanguage: inputLanguage,
            outputLanguage: outputLanguage,
            inputTextView: inputTextView,
            outputTextView: outputTextView
        )
    }
    // Translating the opposite direction (output language to input language)
    @IBAction func translateDownButtonHeld(_ sender: UIButton) {
        guard
            let inputLanguage = self.outputLanguagePickerController.selectedLanguage,
            let outputLanguage = self.inputLanguagePickerController.selectedLanguage else {
                self.showError(message: "Invalid language selections")
                return
        }
        transcribe(
            inputLanguage: inputLanguage,
            outputLanguage: outputLanguage,
            inputTextView: outputTextView,
            outputTextView: inputTextView
        )
    }

    @IBAction func translateButtonLifted(_ sender: UIButton) {
        view.sendSubviewToBack(fadedView)
        listener.stopRecordingAudio()
    }

    let inputLanguagePickerController = InputLanguagePickerController()
    let outputLanguagePickerController = LanguagePickerController()

    // Immediately start loading supported input languages, translations, and output languages
    let listener = Listener()
    let translator = Translator()
    let speaker = Speaker()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Pause screen loading until supported input languages and translations are loaded
        while (!translator.translationsLoaded || !listener.inputLanguagesLoaded) { }

        AVAudioSession.sharedInstance().requestRecordPermission { _ in }

        configureTranslationButtons()
        configureTextViews()
        configureLanguagePickers()
    }

    func configureTranslationButtons() {
        UIView.animate(withDuration: 0.0) {
            self.translateDownButton.transform = CGAffineTransform(rotationAngle: .pi)
        }
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

        // This must be called AFTER inputLanguagePickerController.picker has been set
        inputLanguagePickerController.translator = translator
        inputLanguagePickerController.listener = listener
        inputLanguagePickerController.outputLanguagePickerController = outputLanguagePickerController
    }

    func transcribe(
        inputLanguage: Language,
        outputLanguage: Language,
        inputTextView: UITextView,
        outputTextView: UITextView)
    {
        view.bringSubviewToFront(fadedView)
        listener.startRecordingAudio(language: inputLanguage) { [weak self] transcription, error in
            DispatchQueue.main.async {
                if let transcription = transcription {
                    inputTextView.text = transcription
                    self?.translate(transcription, inputLanguage: inputLanguage, outputLanguage: outputLanguage, outputTextView: outputTextView)
                }
                else if let error = error {
                    self?.showError(message: error)
                }
            }
        }
    }

    // Translates the input text and displays it in the output text
    // Once the translation is completed, it is read aloud
    func translate(
        _ text: String,
        inputLanguage: Language,
        outputLanguage: Language,
        outputTextView: UITextView)
    {
        translator.translate(
            text,
            inputLanguage: inputLanguage,
            outputLanguage: outputLanguage)
        {
            [weak self] translation, error in

            DispatchQueue.main.async {
                if let translation = translation {
                    outputTextView.text = translation
                    self?.speaker.readAloud(text: translation, language: outputLanguage)
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
