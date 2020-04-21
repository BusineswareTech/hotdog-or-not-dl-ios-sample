//
//  DLModelsInteractor.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 09.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import RxSwift
import Vision

protocol IDLModelsInteractor {
    func getRemoteModelsList() -> Single<[DLModelInfo]>
    func getDownloadedRemoteModelsList() -> Single<[DLModelDetails]>
    func getLocalUserModelsList() -> Single<[DLModelDetails]>
    func getRemoteUserModelList() -> Single<[DLModelInfo]>
    func downloadModel(id: String) -> Observable<DLModelProgressDetails>
    func uploadModel(model: DLModelUpload) -> Observable<DLModelProgressUpload>
    func getLocalModel(id: String) -> Single<DLModelDetails?>
    func uploadImage(url: URL?) -> Observable<ImageProgressUpload>
}

class DLModelsInteractor: IDLModelsInteractor {
    let repository: IDLModelsRepository = DI.getDLModelsRepository()
    
    func getRemoteModelsList() -> Single<[DLModelInfo]> {
        return repository.getCommonModelsList()
    }
    
    func getDownloadedRemoteModelsList() -> Single<[DLModelDetails]> {
        return repository.getLocalModelsList()
    }
    
    func getLocalUserModelsList() -> Single<[DLModelDetails]> {
        return repository.getLocalUserModelsList(by: "default")
    }
    
    func getRemoteUserModelList() -> Single<[DLModelInfo]> {
        return repository.getRemoteUserModelsList(by: "default")
    }
    
    func downloadModel(id: String) -> Observable<DLModelProgressDetails> {
        return Observable.create { observer in
            var model: DLModelDetails?
            
            let bag = DisposeBag()
            
            self.repository.getModel(id: id)
                .subscribe(
                    onNext: {
                        print("Interactor", $0.progress)
                        observer.onNext($0)
                        if $0.details?.fileURL != nil {
                            model = $0.details
                        }
                    }, onError: {
                    observer.onError($0)
                }, onCompleted: {
                    if let model = model {
                        self.repository.saveLocalModel(dlModelDetails: model)
                            .subscribe(onSuccess: { (success) in
                                observer.onCompleted()
                            }, onError: {
                                observer.onError($0)
                            }).disposed(by: bag)
                    }
                }).disposed(by: bag)
            
            return Disposables.create()
        }
    }
    
    private func getMockDetailsFor(id: String, fileURL: String?) -> DLModelDetails {
        return DLModelDetails(
        imgURL: "http://www.myiconfinder.com/uploads/iconsets/256-256-154c5e0fbdeb67938fe7a5de18677fb0-hotdog.png",
        id: id,
        fileURL: fileURL,
        name: "Hotdog",
        modelType: .coreml,
        userId: "default")
    }
    
    func uploadModel(model: DLModelUpload) -> Observable<DLModelProgressUpload> {
        return repository.uploadModel(model: model)
    }
    
    func uploadImage(url: URL?) -> Observable<ImageProgressUpload> {
        return repository.uploadImage(url: url!)
    }
    
    func getLocalModel(id: String) -> Single<DLModelDetails?> {
        return repository.getLocalModel(id: id)
    }
}
