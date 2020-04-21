//
//  DLModelUploadingViewModel.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 22.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class DLModelUploadingViewModel {
    var fileURL: String?
    var imgURL: URL?
    var imgRemoteURL: String?
    var name = BehaviorRelay<String>(value: "")
    var modelProgress = BehaviorSubject<Double>(value: 0.0)
    var imageProgress = BehaviorSubject<Double>(value: 0.0)
    var isModelUploaded = BehaviorSubject<Bool>(value: false)
    var errorMessage = PublishSubject<String>()
    
    let bag = DisposeBag()
    var isUploading = false
    
    private var interactor = DI.getDLModelsInteractor()
    
    func validateCredentials() -> Bool {
//        return true
        let modelName = name.value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return modelName.count > 0 && fileURL != nil
    }
    
    func fileChosen(url: String?) {
        fileURL = url
    }
    
    func imgChosen(url: URL?) {
        imgURL = url
    }
    
    func uploadTapped() {
        guard isUploading == false else { return }
        isUploading = true
        if validateCredentials() {
            if imgURL != nil {
                uploadImg(completion: uploadModel)
            } else {
                uploadModel(imgURL: nil)
            }
        } else {
            isUploading = false
            errorMessage.onNext("Incorrect credentials")
        }
    }
    
    private func uploadImg(completion: @escaping (_ urlPath: String?) -> Void) {
        var imgRemoteUrlPath: String?
        
        interactor.uploadImage(url: imgURL)
        .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
        .subscribe(onNext: { (progressUpload) in
            print(progressUpload)
            imgRemoteUrlPath = progressUpload.imgURL
            self.imageProgress.onNext(progressUpload.progress ?? 1)
        }, onError: { (error) in
            print(error)
            self.imageProgress.onNext(0)
            self.errorMessage.onNext("Error while uploading image")
        }, onCompleted: {
            print("Uploading is completed")
            completion(imgRemoteUrlPath)
        }).disposed(by: bag)
    }
    
    private func uploadModel(imgURL: String?) {
        let modelName = name.value.trimmingCharacters(in: .whitespacesAndNewlines)
        interactor.uploadModel(model: DLModelUpload(fileURL: fileURL, imgURL: imgURL, name: modelName))
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (progressUpload) in
                   print(progressUpload)
                    self.modelProgress.onNext(progressUpload.progress ?? 1)
               }, onError: { (error) in
                    print(error.localizedDescription)
                    self.isUploading = false
                    self.modelProgress.onNext(0)
                
                    self.errorMessage.onNext("Error while uploading file" + error.localizedDescription)
               }, onCompleted: {
                self.isUploading = false
                self.isModelUploaded.onNext(true)
                   print("Uploading is completed")
               }).disposed(by: bag)
    }
}
