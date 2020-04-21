//
//  SplashLoadingCoordinator.swift
//  mlrecognizer
//
//  Created by Alexandr Mikhailov on 24.09.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import UIKit

final class ModelCoordinator: Coordinator {
    let navController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    func start() {
        openSplashScreen()
    }
    
    private func openSplashScreen() {
        let splashVC = UIStoryboard(name: "Model", bundle: nil).instantiateViewController(withIdentifier: "SplashLoadingViewController") as! SplashLoadingViewController
        
        let splashVM = SplashLoadingViewModel()
        splashVC.delegate = self
        splashVC.vm = splashVM
        
        navController.setViewControllers([splashVC], animated: true)
    }
    
    private func openTutorialScreen() {
        let tutorialVC = UIStoryboard(name: "Model", bundle: nil).instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        tutorialVC.delegate = self
        navController.setViewControllers([tutorialVC], animated: true)
    }
    
    private func openMainScreen() {
        let mainVC = UIStoryboard(name: "Model", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        let mainVM = MainViewModel()
        mainVC.viewModel = mainVM
        mainVC.delegate = self
        
        navController.setViewControllers([mainVC], animated: true)
    }
    
    private func openSettingsScreen() {
        DispatchQueue.main.async {
            let settingsVC = UIStoryboard(name: "Model", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
                             
            settingsVC.navigationDelegate = self
            self.navController.pushViewController(settingsVC, animated: true)
       }
    }
    
    private func openUploadScreen(_ completion: (() -> Void)?) {
        let uploadingVC = UIStoryboard(name: "Model", bundle: nil).instantiateViewController(withIdentifier: "DLModelUploadingViewController") as! DLModelUploadingViewController
        uploadingVC.modalPresentationStyle = .overFullScreen
        
        uploadingVC.delegate = self
        uploadingVC.uploadCompletion = completion
        navController.present(uploadingVC, animated: true, completion: nil)
    }
}

extension ModelCoordinator: TutorialViewControllerDelegate {
    func nextButtonTapped() {
        UserManager.shared.setTutorialShown(true)
        openMainScreen()
    }
}

extension ModelCoordinator: SplashLoadingDelegate {
    func onLoadedResources(vc: UIViewController) {
        openMainScreen()
    }
}

extension ModelCoordinator: CameraScreenDelegate {
    func onSettingsTapped() {
        openSettingsScreen()
    }
}

extension ModelCoordinator: SettingsScreenDelegate {
    func onUploadTapped(completion: (() -> Void)?) {
        openUploadScreen(completion)
    }
}

extension ModelCoordinator: DLModelUploadingViewControllerDelegate {
    func cancelTapped() {
        navController.dismiss(animated: true, completion: nil)
    }
    
    func modelUploaded(completion: (() -> Void)?) {
        completion?()
        navController.dismiss(animated: true, completion: nil)
    }
}
