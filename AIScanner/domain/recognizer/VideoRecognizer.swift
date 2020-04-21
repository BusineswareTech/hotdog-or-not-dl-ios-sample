//
//  Recognizer.swift
//  mlrecognizer
//
//  Created by Alexandr Mikhailov on 10.09.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import UIKit
import Vision
import RxSwift

class VideoRecognizer {
    private let capture: VideoCapture!
    private var recognizer: IRecognizer?
    private let bag = DisposeBag()
    
    var handleResult: ((_ featureValue: MLFeatureValue) -> Void)?
    
    init(capture: VideoCapture?) {
        self.capture = capture
        
        DLModelState.shared.dlModelDetailsObservable.bind { [weak self] (dlModelDetails) in
            self?.recognizer = RecognizerFactory.getRecognizerBy(model: dlModelDetails)
            self?.recognizer?.listener = { [weak self] featureValue in
                self?.handleResult?(featureValue)
            }
        }.disposed(by: bag)
        
        setupCapture()
    }
    
    public func start() {
        capture?.startCapture()
    }
    
    public func stop() {
        capture?.stopCapture()
    }
    
    private func setupCapture() {
        capture?.imageCallback = { [weak self] pixelBuffer in
            self?.recognizer?.recognize(pixelBuffer: pixelBuffer)
        }
    }
}
