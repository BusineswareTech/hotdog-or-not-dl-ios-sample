//
//  SplashLoadingViewModel.swift
//  mlrecognizer
//
//  Created by Alexandr Mikhailov on 20.09.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import Vision
import RxSwift

class SplashLoadingViewModel {
    var isShouldTransit = PublishSubject<Bool>()
    
    let dlModelsInteractor = DI.getDLModelsInteractor()
    let bag = DisposeBag()
    
    func viewDidLoad() {
        loadModel()
    }
    
    private func loadModel() {
        DLModelState.shared.restoreLastModel()
        
        self.isShouldTransit.onNext(true)
        self.isShouldTransit.onCompleted()
    }
}
