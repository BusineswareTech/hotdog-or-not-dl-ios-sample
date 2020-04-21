//
//  UserModelsSettingsViewModel.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 14.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import RxSwift

class UserModelsSettingsViewModel {
    private let interactor = DI.getDLModelsInteractor()
    private var localModelList: [DLModelDetails] = []
    private var remoteModelList: [DLModelInfo] = []
    private let bag = DisposeBag()
    
    var showProgressBar = BehaviorSubject<Bool>(value: true)
    var allModelsList = BehaviorSubject<[DLModelInfoItem]>(value: [])
    var selectedId: String?
    var downloadingModelsIds: [String] = []
    
    init() {
        DLModelState.shared.dlModelDetailsObservable.subscribe(onNext: { model in
            self.updateAllModelList()
            }).disposed(by: bag)
    }
    
    func downloadModelsList() {
        showProgressBar.onNext(true)
        
        interactor.getRemoteUserModelList().subscribe(onSuccess: { [unowned self] (list) in
            self.showProgressBar.onNext(false)
            self.remoteModelList = list
            self.updateList()
        }, onError: { (error) in
            self.showProgressBar.onNext(false)
            self.updateList()
        }).disposed(by: bag)
        
        interactor.getLocalUserModelsList().subscribe(onSuccess: { [unowned self] (list) in
            self.showProgressBar.onNext(false)
            self.localModelList = list
            self.updateList()
        }, onError: { (error) in
            self.showProgressBar.onNext(false)
            self.updateList()
        }).disposed(by: bag)
    }
    
    func downloadModel(id: String) {
        guard downloadingModelsIds.contains(id) == false else { return }
        
        downloadingModelsIds.append(id)
        
        interactor.downloadModel(id: id)
            .subscribe(onNext: { [unowned self] (progressDetails) in
                print("ViewModel")
                do {
                    let list = try self.allModelsList.value()
                    let info = DLInfoMapper.mapFrom(dlModelProgressDetails: progressDetails, isActive: progressDetails.details?.id == DLModelState.shared.activeId)
                    self.allModelsList.onNext(list.map {
                        if ($0.id != info.id) {
                            return $0
                        } else {
                            return info
                        }
                    })
                    print("ViewModel Done")
                } catch {
                    print(error)
                }
            }, onError: { error in
                print(error)
                self.downloadingModelsIds = self.downloadingModelsIds.filter { $0 != id }
            }, onCompleted: {
                self.downloadingModelsIds = self.downloadingModelsIds.filter { $0 != id }
            }).disposed(by: bag)
    }
    
    func applyModel(_ dlModelInfoItem: DLModelInfoItem) {
        guard dlModelInfoItem.id != DLModelState.shared.activeId,
            dlModelInfoItem.fileURL != nil else {
            return
        }
        
        DLModelState.shared.setModel(dlModelDetails: DLInfoMapper.mapToDetails(dlModelInfoItem: dlModelInfoItem))
        updateAllModelList()
    }
    
    private func updateList() {
        self.allModelsList.onNext(mergeLists())
    }
    
    private func updateAllModelList() {
        do {
            let list = try allModelsList.value()
            allModelsList.onNext(list.map {
                DLModelInfoItem(
                    imgURL: $0.imgURL,
                    id: $0.id,
                    name: $0.name,
                    fileURL: $0.fileURL,
                    progress: $0.progress,
                    isActive: $0.id == DLModelState.shared.activeId,
                    modelType: $0.modelType)
            })
        } catch {
            print(error)
        }
    }
    
    private func mergeLists() -> [DLModelInfoItem] {
        let localIds = localModelList.map {
            $0.id
        }
        
        let unDownloadedModels = remoteModelList.filter {
            !localIds.contains($0.id)
        }.compactMap{ info in
            DLInfoMapper.mapFrom(dlModelInfo: info, isActive: info.id == DLModelState.shared.activeId)
        }
        
        let list = localModelList.map {
            DLInfoMapper.mapFrom(dlModelDetails: $0, isActive: $0.id == DLModelState.shared.activeId)
        } + unDownloadedModels
        
        return list
    }
}
