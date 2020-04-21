//
//  AppCoordinator.swift
//  mlrecognizer
//
//  Created by Alexandr Mikhailov on 24.09.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    // MARK: - Properties
    private let navController: UINavigationController
    private let window: UIWindow
    
    // MARK: - Initializer
    init(navController: UINavigationController, window: UIWindow) {
        self.navController = navController
        self.window = window
    }
    
    func start() {
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
        showSplash()
    }
    
    // MARK: - Navigation
    private func showSplash() {
        let splashCoordinator = ModelCoordinator(navController: self.navController)
        splashCoordinator.start()
    }
}
