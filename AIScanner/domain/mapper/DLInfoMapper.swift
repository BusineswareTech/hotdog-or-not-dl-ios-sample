//
//  DLInfoMapper.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 14.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation

struct DLInfoMapper {
    static func mapFrom(dlModelProgressDetails: DLModelProgressDetails, isActive: Bool) -> DLModelInfoItem {
        return DLModelInfoItem(
            imgURL: dlModelProgressDetails.details?.imgURL,
            id: dlModelProgressDetails.details?.id,
            name: dlModelProgressDetails.details?.name,
            fileURL: dlModelProgressDetails.details?.fileURL,
            progress: dlModelProgressDetails.progress,
            isActive: isActive,
            modelType: dlModelProgressDetails.details?.modelType)
    }
    
    static func mapFrom(dlModelInfo: DLModelInfo, isActive: Bool) -> DLModelInfoItem {
        return DLModelInfoItem(
            imgURL: dlModelInfo.imgURL,
            id: dlModelInfo.id,
            name: dlModelInfo.name,
            fileURL: nil,
            progress: nil,
            isActive: isActive,
            modelType: dlModelInfo.modelType)
    }
    
    static func mapFrom(dlModelDetails: DLModelDetails, isActive: Bool) -> DLModelInfoItem {
        return DLModelInfoItem(
            imgURL: dlModelDetails.imgURL,
            id: dlModelDetails.id,
            name: dlModelDetails.name,
            fileURL: dlModelDetails.fileURL,
            progress: nil,
            isActive: isActive,
            modelType: dlModelDetails.modelType)
    }
    
    static func mapToDetails(dlModelInfoItem: DLModelInfoItem) -> DLModelDetails {
        return DLModelDetails(
            imgURL: dlModelInfoItem.imgURL,
            id: dlModelInfoItem.id,
            fileURL: dlModelInfoItem.fileURL, name:
            dlModelInfoItem.name,
            modelType: dlModelInfoItem.modelType,
            userId: nil)
    }
    
    static func mapToUpload(model: DLModelUpload) -> DLModelDetailsUploadDTO {
        return DLModelDetailsUploadDTO(
            imgURL: model.imgURL,
            fileURL: model.fileURL,
            name: model.name)
    }
}
