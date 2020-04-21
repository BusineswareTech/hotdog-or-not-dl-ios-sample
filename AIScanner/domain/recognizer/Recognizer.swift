//
//  VideoRecognizer.swift
//  mlrecognizer
//
//  Created by Alexandr Mikhailov on 19.09.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import Vision
import RxSwift

protocol IRecognizer {
    typealias RecognizerResultListener = ((_ featureValue: MLFeatureValue) -> Void)
    var listener: RecognizerResultListener? { get set }
    
    func recognize(pixelBuffer: CVPixelBuffer)
}

class MLModelRecognizer: IRecognizer {
    
    private var model: MLModel?
    private var requests = [VNRequest]()
    
    var listener: RecognizerResultListener?
    
    init(mlModel: MLModel) {
        self.model = mlModel
        initSetup()
    }
    
    public func recognize(pixelBuffer: CVPixelBuffer) {
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        do {
            try imageRequestHandler.perform(requests)
        } catch {
            print(error)
        }
    }
    
    public func recognize(cgImage: CGImage) {
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try imageRequestHandler.perform(requests)
        } catch {
            print(error)
        }
    }
    
    private func initSetup() {
        guard let model = self.model else {return}
        
        do {
            let visionModel = try VNCoreMLModel(for: model)
            
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async(execute: {
                    if let results = request.results {
                        self.processResults(results)
                    }
                })
            })
            
            objectRecognition.imageCropAndScaleOption = .scaleFill
            self.requests = [objectRecognition]
        } catch {
            print(error)
        }
    }
    
    private func processResults(_ results: [Any]) {
        for observation in results where observation is VNCoreMLFeatureValueObservation {
            guard let featureObservation = observation as? VNCoreMLFeatureValueObservation else {
                continue
            }
            
            listener?(featureObservation.featureValue)
        }
    }
}

class PyTorchModelRecognizer: IRecognizer {
    private var model: TorchModule?
    
    var listener: RecognizerResultListener?
    
    init(model: TorchModule) {
        self.model = model
    }
    
    public func recognize(pixelBuffer: CVPixelBuffer) {
        var tensorBuffer = pixelBuffer
        guard let outputs = model?.predict(image: UnsafeMutableRawPointer(&tensorBuffer)) else {
            return
        }
        
//        outputs.
    }
    
    public func recognize(cgImage: CGImage) {
//        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
//        do {
//            try imageRequestHandler.perform(requests)
//        } catch {
//            print(error)
//        }
    }
    
    private func processResults(_ results: [Any]) {
        for observation in results where observation is VNCoreMLFeatureValueObservation {
            guard let featureObservation = observation as? VNCoreMLFeatureValueObservation else {
                continue
            }
            
            listener?(featureObservation.featureValue)
        }
    }
}
