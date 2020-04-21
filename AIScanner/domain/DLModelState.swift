//
//  DLModelKeeper.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 16.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class DLModelState {
    static let shared = DLModelState()
    
    private let userdefaults = UserDefaults(suiteName: "dlmodel")
    private let interactor = DI.getDLModelsInteractor()
    private let bag = DisposeBag()
    
    var dlModelDetailsObservable = BehaviorRelay<DLModelDetails?>(value: nil)
    
    var activeId: String? {
        get {
            return dlModelDetailsObservable.value?.id
        }
    }
    
    func setModel(dlModelDetails: DLModelDetails?) {
        dlModelDetailsObservable.accept(dlModelDetails)
        saveModel()
    }
    
    func restoreLastModel() {
        let id = userdefaults?.string(forKey: "active_id")
        
        if id != nil {
            interactor.getLocalModel(id: id!).subscribe(onSuccess: { [weak self] model in
                if model != nil {
                    self?.dlModelDetailsObservable.accept(model)
                } else {
                    self?.dlModelDetailsObservable.accept(DLModelsFactory.getDefaultCoreMLModel())
                }
            }).disposed(by: bag)
        } else {
            self.dlModelDetailsObservable.accept(DLModelsFactory.getDefaultCoreMLModel())
        }
    }
    
    func saveModel() {
        guard let id = dlModelDetailsObservable.value?.id else {
            return
        }
        
        userdefaults?.set(id, forKey: "active_id")
    }
    
    deinit {
        saveModel()
    }
}

