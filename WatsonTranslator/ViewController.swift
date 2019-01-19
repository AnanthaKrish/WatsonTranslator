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
        translator?.translate(inputTextView.text) { translation in
            DispatchQueue.main.async {
                self.outputTextView.text = translation
            }
        }
    }

    var translator: Translator?
    let languagePickerController = LanguagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        translator = Translator(inputLanguage: .english, outputLanguage: .spanish)

        // It would be easiest for the recipient to view the translation on the device upside-down
        flipViewUpsideDown(outputTextView)

        inputLanguagePicker.dataSource = languagePickerController
        inputLanguagePicker.delegate = languagePickerController
        outputLanguagePicker.dataSource = languagePickerController
        outputLanguagePicker.delegate = languagePickerController
    }

    func flipViewUpsideDown(_ view: UIView) {
        UIView.animate(withDuration: 0.0) {
            view.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
}



class LanguagePickerController: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Language.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Language.allCases[row].displayName
    }
}
