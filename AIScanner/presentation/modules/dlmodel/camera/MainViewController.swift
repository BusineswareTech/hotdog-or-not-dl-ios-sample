//
//  MainViewController.swift
//  mlrecognizer
//
//  Created by Alexandr Mikhailov on 04.09.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import UIKit
import Vision
import RxCocoa
import RxSwift

protocol CameraScreenDelegate {
    func onSettingsTapped()
}

class MainViewController: UIViewController {
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var tutorialView: UIView!
    @IBOutlet weak var closeTutorialButton: UIButton!
    @IBOutlet weak var tutorialContainer: UIView!
    @IBOutlet weak var activeView: UIView!
    @IBOutlet weak var aimView: AimView!
    
    private var videoRecognizer: VideoRecognizer?
    private var capture: VideoCapture?
    private var disposeBag = DisposeBag()
    
    let videoPrefs = VideoPrefs.defaultPrefs()
    var viewModel: MainViewModel? = MainViewModel()
    let bag = DisposeBag()
    
    var delegate: CameraScreenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        capture = VideoCapture(videoPrefs: videoPrefs, layer: videoView.layer)
        videoRecognizer = VideoRecognizer(capture: capture)
        
        bindViewModel()
        setupUI()
        
        viewModel?.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        viewModel?.start()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let capture = capture else {return}
        capture.resizePreview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.stop()
        
        super.viewWillDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        setupAimView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        delegate?.onSettingsTapped()
    }
    
    @IBAction func closeTutorialButtonTapped(_ sender: Any) {
        viewModel?.closeTutorial()
    }
    
    private func bindViewModel() {
        viewModel?.videoRecognizer = videoRecognizer
        viewModel?.result.bind(onNext: {value in
            self.updateWithResult(value: value)
        }).disposed(by: disposeBag)
        
        viewModel?.isShowTutorial.bind(onNext: {value in
            self.setTutorialVisible(value)
        }).disposed(by: disposeBag)
    }
    
    private func setupUI() {
        setupAimView()
        setupIndicator()
        setupButton()
    }
    
    private func setupAimView() {
        aimView.plusWidth = aimView.bounds.width / 2.5
    }
    
    private func setTutorialVisible(_ value: Bool) {
        tutorialContainer.isHidden = !value
        activeView.isHidden = value
    }
    
    private func setupButton() {
        closeTutorialButton.setTitle(NSLocalizedString("Tutorial.NextButton.Text", comment: ""), for: .normal)
    }
    
    private func setupIndicator() {
        self.stateImageView.alpha = 0
        self.stateImageView.layer.shadowOpacity = 0
        self.stateImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.stateImageView.layer.shadowRadius = 10
        self.stateImageView.layer.shadowColor = UIColor.green.cgColor
        self.stateImageView.layer.masksToBounds = false
        
        DLModelState.shared.dlModelDetailsObservable.bind { [weak self] details in
            guard let details = details, let imgURL = details.imgURL else { return }
            self?.stateImageView.kf.setImage(with: URL(string: imgURL))
        }.disposed(by: bag)
    }
    
    private func updateWithResult(value: Double) {
        var alpha = value
        var shadowOpacity: Float = 0.0
        
        if (value < 0.5) {
            alpha = 0
        }
        
        if (value > 0.9) {
            shadowOpacity = 1
        } else {
            shadowOpacity = 0
        }
        
        
        UIView.animate(withDuration: 1 / Double(videoPrefs.fps), animations: {
            self.stateImageView.alpha = CGFloat(alpha)
            self.stateImageView.layer.shadowOpacity = shadowOpacity
        })
    }
}
