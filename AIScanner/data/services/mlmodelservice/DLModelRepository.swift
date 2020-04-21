//
//  MLModelRepository.swift
//  mlrecognizer
//
//  Created by Alexandr Mikhailov on 20.09.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import Vision
import RxSwift

protocol IDLModelsRepository {
    func getModel(id: String) -> Observable<DLModelProgressDetails>
    func getCommonModelsList() -> Single<[DLModelInfo]>
    func getLocalModelsList() -> Single<[DLModelDetails]>
    func getLocalModel(id: String) -> Single<DLModelDetails?>
    func saveLocalModel(dlModelDetails: DLModelDetails) -> Single<Bool>
    func getLocalUserModelsList(by user: String) -> Single<[DLModelDetails]>
    func getRemoteUserModelsList(by user: String) -> Single<[DLModelInfo]>
    func uploadModel(model: DLModelUpload) -> Observable<DLModelProgressUpload>
    func uploadImage(url: URL) -> Observable<ImageProgressUpload>
}

class DLModelsRepository: IDLModelsRepository {
    let mlModelCacheService: IMLModelCacheService = DI.getDLModelsCacheService()
    
    func getModel(id: String) -> Observable<DLModelProgressDetails> {
        return mlModelCacheService.getModel(id: id)
    }
    
    func getCommonModelsList() -> Single<[DLModelInfo]> {
        return mlModelCacheService.getCommonModelsList()
    }
    
    func getLocalModelsList() -> Single<[DLModelDetails]> {
        return mlModelCacheService.getLocalModelsList()
    }
    
    func getLocalModel(id: String) -> Single<DLModelDetails?> {
        return mlModelCacheService.getLocalModel(id: id)
    }
    
    func saveLocalModel(dlModelDetails: DLModelDetails) -> Single<Bool> {
        return mlModelCacheService.saveLocalModel(dlModelDetails: dlModelDetails)
    }
    
    func getLocalUserModelsList(by user: String) -> Single<[DLModelDetails]> {
        return mlModelCacheService.getLocalUserModelsList(by: user)
    }
    
    func getRemoteUserModelsList(by user: String) -> Single<[DLModelInfo]> {
        return mlModelCacheService.getRemoteUserModelsList(by: user)
    }
    
    func uploadModel(model: DLModelUpload) -> Observable<DLModelProgressUpload> {
        return mlModelCacheService.uploadModel(model: model)
    }
    
    func uploadImage(url: URL) -> Observable<ImageProgressUpload> {
        return mlModelCacheService.uploadImage(url: url)
    }
}
