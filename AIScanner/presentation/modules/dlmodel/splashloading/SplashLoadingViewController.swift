//
//  SplashLoadingViewController.swift
//  mlrecognizer
//
//  Created by Alexandr Mikhailov on 20.09.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreML

protocol SplashLoadingDelegate: class {
    func onLoadedResources(vc: UIViewController)
}

class SplashLoadingViewController: UIViewController {
    
    let bag = DisposeBag()
    var vm: SplashLoadingViewModel?
    var delegate: SplashLoadingDelegate?
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVM()
        vm?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func bindVM() {
        vm?.isShouldTransit.observeOn(MainScheduler.instance).bind { (value) in
            self.loader.isHidden = value
            self.delegate?.onLoadedResources(vc: self)
            self.delegate = nil
        }.disposed(by: bag)
    }
}
