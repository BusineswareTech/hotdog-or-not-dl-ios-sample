//
//  UserManager.swift
//  mlrecognizer
//
//  Created by Alexandr Mikhailov on 25.09.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    
    let userDefaults: UserDefaults?
    
    private init() {
        userDefaults = UserDefaults(suiteName: "User")
    }
    
    func wasTutorialShown() -> Bool {
        return userDefaults?.bool(forKey: "Tutorial") ?? false
    }
    
    func setTutorialShown(_ value: Bool) {
        userDefaults?.set(value, forKey: "Tutorial")
    }
}
