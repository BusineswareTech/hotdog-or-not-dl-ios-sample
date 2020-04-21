//
//  DLModelDownloadMapper.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 08.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation

protocol IDLModelsDownloadMapper {
    func mapFrom(
        dlModelDetailsDownload: DLModelDetailsDownloadDTO,
        dlModelProgress: DLModelDetailsProgressDTO) -> DLModelProgressDetails
    func mapFrom(dlModelInfoDownload: DLModelInfoDTO) -> DLModelInfo
}

class DLModelsDownloadMapper: IDLModelsDownloadMapper {
    func mapFrom(
        dlModelDetailsDownload: DLModelDetailsDownloadDTO,
        dlModelProgress: DLModelDetailsProgressDTO) -> DLModelProgressDetails {
        
        return DLModelProgressDetails(
            progress: dlModelProgress.progress,
            details: DLModelDetails(
                        imgURL: dlModelDetailsDownload.imgURL,
                        id: dlModelDetailsDownload.id,
                        fileURL: dlModelProgress.filePath,
                        name: dlModelDetailsDownload.name,
                        modelType: dlModelDetailsDownload.modelType,
                        userId: dlModelDetailsDownload.userId))
    }
    
    func mapFrom(dlModelInfoDownload: DLModelInfoDTO) -> DLModelInfo {
        return DLModelInfo(
            imgURL: dlModelInfoDownload.imgURL,
            id: dlModelInfoDownload.id,
            name: dlModelInfoDownload.name,
            modelType: DLModelType(rawValue: dlModelInfoDownload.modelType),
            userId: dlModelInfoDownload.userId)
    }
}
