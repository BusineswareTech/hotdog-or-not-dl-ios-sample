//
//  DLModelsFactory.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 16.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation

struct DLModelsFactory {
    static func getDefaultCoreMLModel() -> DLModelDetails? {
        
        if let path = Utils.copyFileToDocumentsFolder(resourcePath: "models/mobilenet8", nameForFile: "mobilenet8", extForFile: "mlmodel")?.path {
            return DLModelDetails(
                imgURL: "http://www.myiconfinder.com/uploads/iconsets/256-256-154c5e0fbdeb67938fe7a5de18677fb0-hotdog.png",
                id: "-1",
                fileURL: path,
                name: "Hotdog PreInstalled",
                modelType: .coreml,
                userId: "default")
        } else {return nil}
    }
}
