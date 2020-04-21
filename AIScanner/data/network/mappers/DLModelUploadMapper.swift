//
//  DLModelMapper.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 08.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation

protocol IDLModelUploadMapper {
    func mapFrom(dlModelDetails: DLModelDetails) -> DLModelDetailsUploadDTO
    func mapFrom(response: DLModelDetailsUploadResponseDTO) -> DLModelProgressUpload
    func mapFrom(response: ImageProgressUploadResponseDTO) -> ImageProgressUpload
}

class DLModelUploadMapper: IDLModelUploadMapper {
    func mapFrom(dlModelDetails: DLModelDetails) -> DLModelDetailsUploadDTO {
        return DLModelDetailsUploadDTO(
            imgURL: dlModelDetails.imgURL,
            fileURL: dlModelDetails.fileURL,
            name: dlModelDetails.name)
    }
    
    func mapFrom(response: DLModelDetailsUploadResponseDTO) -> DLModelProgressUpload {
        return DLModelProgressUpload(
            progress: response.progress,
            id: response.id,
            modelType: response.modelType)
    }
    
    func mapFrom(response: ImageProgressUploadResponseDTO) -> ImageProgressUpload {
        return ImageProgressUpload(progress: response.progress, imgURL: response.imgURL)
    }
}
