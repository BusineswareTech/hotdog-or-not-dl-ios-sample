//
//  DLModelDBMapper.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 17.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation

protocol IDLModelDBMapper {
    func mapFrom(dlModelDetailsEntity: DLModelDetailsEntity) -> DLModelDetails
    func mapFrom(dlModelDetails: DLModelDetails) -> DLModelDetailsEntity
}

class DLModelDBMapper: IDLModelDBMapper {
    func mapFrom(dlModelDetailsEntity: DLModelDetailsEntity) -> DLModelDetails {
        return DLModelDetails(
            imgURL: dlModelDetailsEntity.imgURL,
            id: dlModelDetailsEntity.id,
            fileURL: dlModelDetailsEntity.fileURL,
            name: dlModelDetailsEntity.name,
            modelType: dlModelDetailsEntity.modelTypeEnum,
            userId: dlModelDetailsEntity.userId)
    }
    
    func mapFrom(dlModelDetails: DLModelDetails) -> DLModelDetailsEntity {
        guard let id = dlModelDetails.id else {fatalError("map with no id is aborted")}
        
        let entity = DLModelDetailsEntity()
        entity.id = id
        entity.fileURL = dlModelDetails.fileURL
        entity.imgURL = dlModelDetails.imgURL
        entity.modelTypeEnum = dlModelDetails.modelType
        entity.name = dlModelDetails.name
        entity.userId = dlModelDetails.userId
        
        return entity
    }
}
