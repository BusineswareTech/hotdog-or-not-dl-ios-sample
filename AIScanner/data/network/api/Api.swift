//
//  Api.swift
//  mlrecognizer
//
//  Created by Alexandr Mikhailov on 19.09.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

protocol IApi {
    func downloadModel(id: String) -> Observable<DLModelDetailsProgressDTO>
    func getModelDetails(id: String) -> Single<DLModelDetailsDownloadDTO>
    func uploadModelDetails(model: DLModelDetailsUploadDTO) -> Observable<DLModelDetailsUploadResponseDTO>
    func downloadCommonModelsList() -> Single<[DLModelInfoDTO]>
    func downloadUserModelsList(user: String) -> Single<[DLModelInfoDTO]>
    func uploadImage(localURL: URL) -> Observable<ImageProgressUploadResponseDTO>
}

class Api: IApi {
    private let baseURL = Bundle.main.object(forInfoDictionaryKey: "ServerUrl") as! String
    
    func downloadCommonModelsList() -> Single<[DLModelInfoDTO]> {
        return Single<[DLModelInfoDTO]>.create { single in
            let request = AF.request(self.baseURL + "/models")
                .validate()
                .responseDecodable { (response: DataResponse<[DLModelInfoDTO], AFError>) in
                    print("Success request", response)
                    switch response.result {
                    case .success(let value):
                        single(.success(value))
                    case .failure(let error):
                        //Something went wrong, switch on the status code and return the error
                        switch response.response?.statusCode {
                        case 403:
                            single(.error(ApiError.forbidden))
                        case 404:
                            single(.error(ApiError.notFound))
                        case 409:
                            single(.error(ApiError.conflict))
                        case 500:
                            single(.error(ApiError.internalServerError))
                        default:
                            single(.error(error))
                        }
                    }
            }
                
            //Finally, we return a disposable to stop the request
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func downloadUserModelsList(user: String) -> Single<[DLModelInfoDTO]> {
        return Single<[DLModelInfoDTO]>.create { single in
            let request = AF.request(self.baseURL + "/models/user")
                .validate()
                .responseDecodable { (response: DataResponse<[DLModelInfoDTO], AFError>) in
                    switch response.result {
                        case .success(let value):
                            single(.success(value))
                        case .failure(let error):
                            //Something went wrong, switch on the status code and return the error
                            switch response.response?.statusCode {
                            case 403:
                                single(.error(ApiError.forbidden))
                            case 404:
                                single(.error(ApiError.notFound))
                            case 409:
                                single(.error(ApiError.conflict))
                            case 500:
                                single(.error(ApiError.internalServerError))
                            default:
                                single(.error(error))
                            }
                        }
                }
                
            //Finally, we return a disposable to stop the request
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func uploadImage(localURL: URL) -> Observable<ImageProgressUploadResponseDTO> {
        return Observable.create { observer in
            let headers: HTTPHeaders? = [
                "Authorization": "Client-ID ccefdaa0a1bfa7f"
            ]
            let request = AF.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(localURL, withName: "image")
                },
                to: "https://api.imgur.com/3/upload",
                method: .post,
                headers: headers
            )
            .validate()
            .uploadProgress { progress in
                observer.onNext(
                    ImageProgressUploadResponseDTO(
                        progress: progress.fractionCompleted,
                        imgURL: nil
                    )
                )
            }
            .responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    
                    let response = json as! NSDictionary
                    let data = response.object(forKey: "data") as! NSDictionary
                    
                    observer.onNext(ImageProgressUploadResponseDTO(progress: nil, imgURL: data.object(forKey: "link") as! String))
                    
                    observer.onCompleted()
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func uploadModelDetails(model: DLModelDetailsUploadDTO) -> Observable<DLModelDetailsUploadResponseDTO> {
        return Observable.create { observer in
            if let filePath = model.fileURL, let url = URL(string: filePath) {
                let request = AF.upload(
                    multipartFormData: { multipartFormData in
                        if let imgURL = model.imgURL {
                           multipartFormData.append((imgURL.data(using: .utf8))!, withName: "imgURL")
                        }
                        multipartFormData.append((model.name?.data(using: .utf8))!, withName: "name")
                        multipartFormData.append(url, withName: "file")
                    },
                    to: self.baseURL + "/models/upload")
                .validate()
                .uploadProgress { progress in
                    observer.onNext(
                        DLModelDetailsUploadResponseDTO(
                            progress: progress.fractionCompleted,
                            modelType: nil,
                            id: nil
                        )
                    )
                }
                .responseJSON { (response) in
                    switch response.result {
                    case .success(let json):
                        print("Success with JSON: \(json)")
                        
                        let response = json as! NSDictionary
                        observer.onNext(
                            DLModelDetailsUploadResponseDTO(
                                progress: nil,
                                modelType: DLModelType(
                                    rawValue: response.object(forKey: "modelType") as! String),
                                id: response.object(forKey: "id") as! String))
                        
                        observer.onCompleted()
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    request.cancel()
                }
            } else {
                observer.onError(ApiError.conflict)
                return Disposables.create()
            }
            
        }
    }
    
    func getModelDetails(id: String) -> Single<DLModelDetailsDownloadDTO> {
        return Single<DLModelDetailsDownloadDTO>.create { single in
            //Trigger the HttpRequest using AlamoFire (AF)

            let request = AF.request(self.baseURL + "/models/description/\(id)")
                .validate()
                .responseDecodable { (response: DataResponse<DLModelDetailsDownloadDTO, AFError>) in
                
                switch response.result {
                case .success(let value):
                    //Everything is fine, return the value in onNext
                    single(.success(value))
                case .failure(let error):
                    //Something went wrong, switch on the status code and return the error
                    switch response.response?.statusCode {
                    case 403:
                        single(.error(ApiError.forbidden))
                    case 404:
                        single(.error(ApiError.notFound))
                    case 409:
                        single(.error(ApiError.conflict))
                    case 500:
                        single(.error(ApiError.internalServerError))
                    default:
                        single(.error(error))
                    }
                }
            }
                
            //Finally, we return a disposable to stop the request
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func downloadModel(id: String) -> Observable<DLModelDetailsProgressDTO> {
        return Observable.create { observer in
            let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask, options: .removePreviousFile)

            let request = AF.download(self.baseURL + "/models/download/\(id)", to: destination)
                .validate()
                .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    
                    if (progress.fractionCompleted != 1) {
                        
                        let dto = DLModelDetailsProgressDTO(progress: progress.fractionCompleted, filePath: nil)
                        observer.on(.next(dto))
                    }
                }
                .response { (response) in
                    print(response)
                    
                    if response.error == nil, let path = response.fileURL?.path {
                    observer.onNext(DLModelDetailsProgressDTO(progress: nil, filePath: "file://\(path)"))
                        observer.onCompleted()
                    }
                    
                    if let error = response.error {
                        switch response.response?.statusCode {
                        case 403:
                            observer.onError(ApiError.forbidden)
                        case 404:
                            observer.onError(ApiError.notFound)
                        case 409:
                            observer.onError(ApiError.conflict)
                        case 500:
                            observer.onError(ApiError.internalServerError)
                        default:
                            observer.onError(error)
                        }
                    }
                    
            }
    
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
    case unknown
}
