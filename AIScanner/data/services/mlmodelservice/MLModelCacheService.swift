//
//  MLModelCacheService.swift
//  mlrecognizer
//
//  Created by Alexandr Mikhailov on 20.09.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import RxSwift
import Vision

// Cache Service is used to return cached or own api request. Need to implement.

protocol IMLModelCacheService {
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

class MLModelCacheService: IMLModelCacheService {
    private let userDefaults: UserDefaults?
    private let modelPathKey = "modelPathKey"
    private let compiledModelPathKey = "compiledModelPathKey"
    private let api: IApi = DI.getApi()
    private let dbDAO: IDLModelsDAO = DI.getDLModelsDAO()
    private let bag = DisposeBag()
    private let downloadMapper: IDLModelsDownloadMapper = DLModelsDownloadMapper()
    private let uploadMapper: IDLModelUploadMapper = DLModelUploadMapper()
    private let daoMapper: IDLModelDBMapper = DLModelDBMapper()
    
    init() {
        userDefaults = UserDefaults(suiteName: "mlmodel")
    }
    
    func getModel(id: String) -> Observable<DLModelProgressDetails> {
        return Observable.create { observer in
            self.api.getModelDetails(id: id).subscribe(onSuccess: { value in
                self.api.downloadModel(id: id)
                    .throttle(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.instance)
                    .subscribe({ (event) in
                        if let progressDTO = event.element {
                                observer.onNext(
                                    self.downloadMapper.mapFrom(
                                        dlModelDetailsDownload: value,
                                        dlModelProgress: progressDTO)
                                )
                        } else if let error = event.error {
                            print("Error downloadMode")
                            observer.onError(error)
                        }
                        
                        if event.isCompleted {
                            observer.onCompleted()
                        }
                    }).disposed(by: self.bag)
                }, onError: { error in
                    observer.onError(error)
                }).disposed(by: self.bag)
            
            return Disposables.create()
        }
    }
    
    func getCommonModelsList() -> Single<[DLModelInfo]> {
        return self.api.downloadCommonModelsList()
            .map { dlModelInfoList in
                dlModelInfoList.map {
                    return self.downloadMapper.mapFrom(dlModelInfoDownload: $0)
                }
            }
    }
    
    func getRemoteUserModelsList(by user: String) -> Single<[DLModelInfo]> {
       return self.api.downloadUserModelsList(user: user).map {
            return $0.map {
                self.downloadMapper.mapFrom(dlModelInfoDownload: $0)
            }
       }
    }
    
    func getLocalModelsList() -> Single<[DLModelDetails]> {
        return Single.create { single in
            let models = self.dbDAO.getRemoteModels()
            
            single(.success(models.map {
                return self.daoMapper.mapFrom(dlModelDetailsEntity: $0)
            }))

            return Disposables.create()
        }
    }
    
    func getLocalUserModelsList(by user: String) -> Single<[DLModelDetails]> {
        return Single.create { single in
            let models = self.dbDAO.getModelsBy(user: user)
            
            single(.success(models.map {
                return self.daoMapper.mapFrom(dlModelDetailsEntity: $0)
            }))

            return Disposables.create()
        }
    }
    
    func getLocalModel(id: String) -> Single<DLModelDetails?> {
        return Single.create { single in
            let entity = self.dbDAO.getModelBy(id: id)
            
            if let entity = entity {
                single(
                    .success(
                        self.daoMapper.mapFrom(
                            dlModelDetailsEntity: entity
                        )
                    )
                )
            } else {
                single(.success(nil))
            }

            return Disposables.create()
        }
    }
    
    func saveLocalModel(dlModelDetails: DLModelDetails) -> Single<Bool> {
        return Single.create { single in
            let success = self.dbDAO.insert(
                dlModelDetailsEntity: self.daoMapper.mapFrom(
                    dlModelDetails: dlModelDetails
            ))
            
            single(.success(success))

            return Disposables.create()
        }
    }
    
    func uploadModel(model: DLModelUpload) -> Observable<DLModelProgressUpload> {
        return self.api.uploadModelDetails(
                    model: DLInfoMapper.mapToUpload(model: model)
                )
                .map {
                    return self.uploadMapper.mapFrom(response: $0)
                }
    }
    
    func uploadImage(url: URL) -> Observable<ImageProgressUpload> {
        return self.api.uploadImage(localURL: url)
            .map {
                return self.uploadMapper.mapFrom(response: $0)
        }
    }
}
