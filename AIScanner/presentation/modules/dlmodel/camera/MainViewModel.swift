//
//  MainViewModel.swift
//  mlrecognizer
//
//  Created by Alexandr Mikhailov on 10.09.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import RxSwift
import AVFoundation

class MainViewModel {
    var resultText = PublishSubject<String>()
    var isOn = PublishSubject<Bool>()
    var result = PublishSubject<Double>()
    var isShowTutorial = BehaviorSubject<Bool>(value: !UserManager.shared.wasTutorialShown())
    
    private var previousProbability: Double = 0
    private let soundThresHold = 0.9
    
    private var player: AVAudioPlayer?
    
    var videoRecognizer: VideoRecognizer? {
        didSet {
            videoRecognizer?.handleResult = { [unowned self] result in
                guard let resultArray = result.multiArrayValue else {return}
                
                let probability = exp(resultArray[1].doubleValue) / (exp(resultArray[0].doubleValue) + exp(resultArray[1].doubleValue))
                
                if self.shouldPlaySound(probability: probability) {
                    self.playSound()
                }
                
                self.previousProbability = probability
                    
                self.result.onNext(probability)
            }
        }
    }
    
    init() {
        initPlayer()
    }
    
    func closeTutorial() {
        UserManager.shared.setTutorialShown(true)
        isShowTutorial.onNext(!UserManager.shared.wasTutorialShown())
    }
    
    func start() {
        videoRecognizer?.start()
    }
    
    func stop() {
        videoRecognizer?.stop()
    }
    
    private func initPlayer() {
        guard let url = Bundle.main.url(forResource: "2", withExtension: "mp3") else { return }

        do {
           try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
           try AVAudioSession.sharedInstance().setActive(true)

           player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

        } catch let error {
           print(error.localizedDescription)
        }
    }
    
    private func shouldPlaySound(probability: Double) -> Bool {
        return probability > soundThresHold && previousProbability < soundThresHold
    }

    private func playSound() {
        guard let player = player else { return }
        
        if (!player.isPlaying) {
            player.play()
        }
    }
    
    deinit {
        videoRecognizer?.stop()
    }
}
