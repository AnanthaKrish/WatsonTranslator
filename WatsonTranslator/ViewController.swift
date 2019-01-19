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

    @IBAction func translateButtonTapped(_ sender: UIButton) {
        translator?.translate(inputTextView.text) { translation in
            DispatchQueue.main.async {
                self.outputTextView.text = translation
            }
        }
    }

    var translator: Translator?

    override func viewDidLoad() {
        super.viewDidLoad()
        // It would be easiest for the recipient to view the translation on the device upside-down
        flipViewUpsideDown(outputTextView)

        translator = Translator(inputLanguage: .english, outputLanguage: .spanish)
    }

    func flipViewUpsideDown(_ view: UIView) {
        UIView.animate(withDuration: 0.0) {
            view.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
}
