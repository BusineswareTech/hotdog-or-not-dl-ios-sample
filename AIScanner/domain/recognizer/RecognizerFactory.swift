//
//  RecognizerFactory.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 16.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import Vision

class RecognizerFactory {
    static func getRecognizerBy(model: DLModelDetails?) -> IRecognizer? {
        guard let model = model else {return nil}
        
        switch model.modelType {
        case .coreml:
            guard let filePath = model.fileURL else {return nil}
            guard let url = URL(string: filePath) else {return nil}
            do {
                let compiledUrl = try MLModel.compileModel(at: url)
                let model = try MLModel(contentsOf: compiledUrl)
                let coremlRecognizer = MLModelRecognizer(mlModel: model)
                
                return coremlRecognizer
            } catch {
                return nil
            }
        case .pytorch:
            return nil
        case .none:
            return nil
        }
    }
}
