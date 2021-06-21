//
//  ViewController.swift
//  POCMicroblink
//
//  Created by Miguel Ureña on 6/1/21.
//

import UIKit
import BlinkCard

class ViewController: UIViewController, MBCScanningRecognizerRunnerDelegate  {
    
    var blinkCardRecognizer : MBCBlinkCardRecognizer?
    var recognizer : MBCBlinkCardRecognizer?
    var recognizerRunner: MBCRecognizerRunner?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupRecognizerRunner()
    }
    
    
    @IBAction func didTapManual(_ sender: AnyObject) {
        guard let image = UIImage(named: "card3") else {
            print("Not found")
            return
        }
        processImageRunner(image)
    }

    
    func setupRecognizerRunner() {
        var recognizers = [MBCRecognizer]()
        recognizer = MBCBlinkCardRecognizer()
        blinkCardRecognizer?.extractCvv = false
        blinkCardRecognizer?.extractIban = false
        
        recognizers.append(recognizer!)
        let recognizerCollection = MBCRecognizerCollection(recognizers: recognizers)
        recognizerRunner = MBCRecognizerRunner(recognizerCollection: recognizerCollection)
        recognizerRunner?.scanningRecognizerRunnerDelegate = self
    }

    func processImageRunner(_ originalImage: UIImage?) {
        var image: MBCImage? = nil
        if let anImage = originalImage {
            image = MBCImage(uiImage: anImage)
        }
        image?.cameraFrame = false
        image?.orientation = MBCProcessingOrientation.up
        let _serialQueue = DispatchQueue(label: "com.microblink.DirectAPI-sample-swift")
        guard let mbcImage = image else {
            print("error decoding image")
            return
        }
        
        _serialQueue.async(execute: {() -> Void in
            self.recognizerRunner?.processImage(mbcImage)
        })
    }

    func recognizerRunner(_ recognizerRunner: MBCRecognizerRunner, didFinishScanningWith state: MBCRecognizerResultState) {
        if recognizer?.result.resultState == MBCRecognizerResultState.valid {
            print("Valid")
        } else {
            print("Invalid")
        }
    }

}
